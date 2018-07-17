/* Serial 1: Enviar dado - TX1
   Serial 2: Receber dado - RX2 */
/* -------------------------------------------------------------------- */
// Meu endereço
const int myAddr = 1;
/* -------------------------------------------------------------------- */
// Arduino -> FPGA
const int valueToFPGA[] = {28, 26, 24, 22}; //Enviar valor para o FPGA -> 4 bits
// FPGA -> Arduino
const int sendEndDest[] = {53, 51}; //Endereço para o envio do dado -> 2 bits
//const int sendEndFont[] = {49, 47}; //Endereço que enviou o dado -> 2 bits
const int sendData[] = {45, 43, 41, 39}; //Envio do dado -> 4 bits
// Processador
const int flagSend = 31; //Para indicar que o processador quer enviar o dado
const int flagSent = 33; //Indica que o Arduino já recebeu o dado
const int flagReceive = 47; //Para indicar que o processador quer receber o dado
const int flagReceived = 49; //Indica que o processador recebeu o dado
// Total: 4 + 2 + 2 + 4 + 2 + 1 (GND) = 15 bits
// (Quantidade de ligações com o FPGA)
/* -------------------------------------------------------------------- */
//Variáveis locais
const int size = 30;
int first = 0; //Início da fila
int last = 0; //Fim da fila
int qtdRD = 0; //Quantidade de elementos na fila
int cp = 0; //Controle os pacotes recebidos
//Controla a fila de dados que enviará para o Arduino
int qtdData = 0; //Quantidade de elementos de dados para o FPGA
int firstFPGA = 0;
int lastFPGA = 0;
/* -------------------------------------------------------------------- */
int vetorRD[30]; //Armazenar valores enviados por outro arduino
int vetorDataFPGA[30]; //Armazenar somente os dados que foram recebidos
int estadoFlagSend = 0, estadoFlagSent = 0;
int estadoFlagReceive = 0, estadoFlagReceived = 0;
/* -------------------------------------------------------------------- */
/* -------------------------------------------------------------------- */
/* -------------------------------------------------------------------- */

void setup() {
  /* Comunicação com o processador */
  pinMode(flagSend, INPUT);
  pinMode(flagSent, OUTPUT);
  pinMode(flagReceive, INPUT);
  pinMode(flagReceived, OUTPUT);
  for(int i = 0; i < 4; i++){
    pinMode(valueToFPGA[i], OUTPUT);
    pinMode(sendData[i], INPUT);
  }
  for(int i = 0; i < 2; i++){
    pinMode(sendEndDest[i], INPUT);
    //pinMode(sendEndFont[i], INPUT);
  }
  Serial.begin(19200);
  Serial1.begin(9600);
  Serial2.begin(9600);
}

/* -------------------------------------------------------------------- */
/* -------------------------------------------------------------------- */
/* -------------------------------------------------------------------- */

void loop() {
  delay(30);
  estadoFlagSend = digitalRead(flagSend);
  estadoFlagSent = digitalRead(flagSent);
  estadoFlagReceive = digitalRead(flagReceive);
  estadoFlagReceived = digitalRead(flagReceived);
  /* Enviar dado para outro Arduino */
  if(estadoFlagSend == HIGH && estadoFlagSent == LOW){
    //Processador -> Arduino
    sendToArduino();
    digitalWrite(flagSent, HIGH); //Envia para o processador
    Serial.println("Recebe do processador!");
  } else { /* Preparar para o próximo envio */
    digitalWrite(flagSent, LOW);
  }
  /* ------------------------------------ */
  if(estadoFlagReceive == HIGH && estadoFlagReceived == LOW && qtdData != 0){
    sendToFPGA();
    digitalWrite(flagReceived, HIGH); //Envia para o processador
    Serial.println("Envia dado para o processador!");
  } else {
    digitalWrite(flagReceived, LOW);
  }
  /* Verifica se algo está sendo recebido */
  receivePackage();
  checkPackage();
  delay(1000);
}

/* -------------------------------------------------------------------- */
/* ----------------------- Funções Principais ------------------------- */
/* -------------------------------------------------------------------- */

// Verifica se há pacotes recebidos
void checkPackage(){
  if(qtdRD > 0){
    if(vetorRD[first] == myAddr){
      vetorDataFPGA[lastFPGA] = vetorRD[first+2];
      qtdData++;
      if(lastFPGA < size - 1) lastFPGA++;
      else lastFPGA = 0;
      Serial.println("=== CheckPackage: Recebi o valor! ===");
      updateValue(); //Função auxiliar
    } else {
      if(vetorRD[first] <= 3){
        //Enviar valor para o outro Arduino
        sendPackage(vetorRD[first], vetorRD[first+1], vetorRD[first+2]);
        /* Mostrar valores no monitor*/
        Serial.println("=== CheckPackage: Repassa! ===");
        Serial.print("Destino: ");
        Serial.println(vetorRD[first]);
        Serial.print("Fonte: ");
        Serial.println(vetorRD[first+1]);
        Serial.print("Dado: ");
        Serial.println(vetorRD[first+2]);
        Serial.println();
        /* FIM */
        updateValue(); //Função auxiliar
      }
    }
    delay(100);
  }
}

// Receber valores e armazenar no vetor
void receivePackage(){
  while(Serial2.available() > 0){
    controlQtd(); //Função auxiliar
    int dByte = Serial2.read();
    vetorRD[last] = dByte;
    /* Mostrar valor no monitor */
    Serial.println("=== ReceivePackage: recebe pela porta Serial ===");
    Serial.print("Dado: ");
    Serial.println(dByte);
    Serial.println();
    /* FIM */
    if(last < size - 1) last++;
    else last = 0;
  }
}

//Conversão do dado para binário
void sendToFPGA(){
  int j = 3;
  int value = vetorDataFPGA[firstFPGA];
  Serial.print("Valor enviado para o FPGA:");
  Serial.println(value);
  qtdData--;
  if(firstFPGA < size - 1) firstFPGA++;
  else firstFPGA = 0;
  for(int i = 0; i < 4; i++){
    byte state = bitRead(value, i);
    if(state == 0) digitalWrite(valueToFPGA[j], LOW);
    else digitalWrite(valueToFPGA[j], HIGH);
    j--;
  }
  //updateValue();
}

//Processador -> Arduino
void sendToArduino(){
  int dest, font, data;
  //Função auxiliar
  dest = convertToInt(sendEndDest, 2); //Destino
  //font = convertToInt(sendEndFont, 2); //Fonte
  font = myAddr;
  data = convertToInt(sendData, 4); //Dado
  /* Mostrar valores no monitor*/
  Serial.println("=== SendToArduino: Envia para o Arduino ===");
  Serial.print("Destino: ");
  Serial.println(dest);
  Serial.print("Fonte: ");
  Serial.println(font);
  Serial.print("Dado: ");
  Serial.println(data);
  Serial.println();
  /* FIM */
  sendPackage(dest, font, data); //Enviar valores
}

// Enviar os endereços e o valor para o outro Arduino
void sendPackage(int addrSource, int addrDest, int value){
  send(addrSource);
  send(addrDest);
  send(value);
}

// Enviar dado para a outra porta
void send(int data){
  Serial1.write(data);
}


/* -------------------------------------------------------------------- */
/* ------------------------- Funções auxiliares ----------------------- */
/* -------------------------------------------------------------------- */

//Converter valor para decimal
int convertToInt(int *v, int tam){
  int value = 0, j = 0;
  for(int i = tam-1; i >= 0; i--) {
    if(digitalRead(v[i]) == HIGH){
      value += potencia(2, j);
    }
    j++;
  }
  return value;
}

// Atualizar o valor
void updateValue(){
  if(first + 3 < size - 1) first += 3;
  else first = 0;
  qtdRD--;
}

//Controla a quantidade de itens foram recebidos
void controlQtd(){
  cp++;
  if(cp >= 3){
    qtdRD++;
    cp = 0;
  }
}

int potencia(int a, int b){
  int result = 1;
  for(int i = 0; i < b; i++){
    result = result * a;
  }
  return result;
}

/* -------------------------------------------------------------------- */
/* ------------------------- Funções para teste ----------------------- */
/* -------------------------------------------------------------------- */


/* Ler valor do monitor serial
 * Imprimir o valor como inteiro
 */

/*
if(Serial.available() > 0){
  int a = Serial.parseInt();
  Serial.println(a);
}
*/
