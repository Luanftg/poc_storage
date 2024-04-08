# poc_storage

- Repositório criado com o objetivo de testar a viabilidade de criação de um diretório e persistência de um arquivo no *External Storage* do dispositivo *Android*.

## Atividades

### 1° PARTE

- [x] Criação do projeto flutter para plataforma android
- [x] Inclusão das permissões:  MANAGE_EXTERNAL_STORAGE, READ_EXTERNAL_STORAGE e WRITE_EXTERNAL_STORAGE
- [x] Utilização do pacote *path_provider* para buscar o caminho do *External Storage Directories*
- [x] Implementação da classe *ExtStorage* para criar diretórios dentro das pastas "padrões" do SD Card
- [x] Criação de interface do usuário simples para criar e persistir um arquivo no diretório criado
- [x] Verificação de persistência após deleção do aplicativo - evidencia em Anexo: _persistencia_arquivo_

### 2° PARTE: Exclusão

- [x] Instalação do pacote *permission_handler* https://pub.dev/packages/permission_handler para solicitar permissões para gerenciar *external_storage*

*Estratégia de Deleção*: Utilizar a propriedade *Data de Modificação* do arquivo para gerenciar a exclusão automática. Estabelecer uma faixa de dias em que o arquivo deve ser persistido no dispositivo físico.

h3. 3° PARTE: Criptografia

- [x] Criação da classe *Criptografia* responsável por encapsular a lógica de cripto e descripto
- [x] Criação da interface *EstrategiaCriptografia* com as assinaturas de cripto e descripto a partir de um texto
- [x] Implementação do contrato de Estratégia de Cripto com o pacote *encrypt* https://pub.dev/packages/encrypt

> *Utilização do modo ECB(Electronic Code Book)* _is the simplest encryption mode and does not require IV for encryption. The input plain text will be divided into blocks and each block will be encrypted with the key provided and hence identical plain text blocks are encrypted into identical cipher text blocks._

- [x] Verificação de funcionamento da criptografia no arquivo persistido e da descriptografia ao ler o arquivo - evidencia em Anexo: _cripto_descripto_arquivo_


## Resultado do Spike

*Foram possíveis produzir, com aproveitamento para o APP - EasyPac:*
- Uma classe: *Criptografia* com um contrato: *Estratégia de Criptografia* que define as assinaturas de criptografar e descriptografar um texto.
- Uma implementação do contrato de Estratégia com *AESEstrategiaCriptografia* com o pacote *encrypt* https://pub.dev/packages/encrypt
- Uma classe *ExtStorage* responsável por devolver  o caminho do diretório criado na raiz do dispositivo móvel - ou já existente
- Uma classe *FileControler* responsável por gerenciar a criação, armazenamento e criptografria do arquivo persistido.

- Projeto criado em: https://github.com/Luanftg/poc_storage