# Católica MHC — App de Horas Complementares

Aplicativo mobile desenvolvido em **Flutter** para gerenciamento e acompanhamento de **Horas Complementares** universitárias (Projeto PAC — 4ª Fase de Engenharia de Software).

Originalmente criado em **2022**, o projeto foi modernizado em **2026** para compatibilidade com **Flutter 3 / Dart 3 (Sound Null Safety)**, **Gradle Kotlin DSL**, SDKs atuais do Android e versões recentes do **Firebase**.

---

## Funcionalidades

- **Autenticação (Firebase Auth):** Login, cadastro de estudantes e recuperação de senha (com suporte a telas padrão e tema escuro).
- **Dashboard de Progresso:** Visualização das horas complementares por categoria (*Estágio*, *Palestra*, *Outros*) em gráfico de rosca interativo (`SfCircularChart`), barra de progresso percentual e resumo detalhado.
- **Gestão de Certificados (Cloud Firestore):** Envio, visualização de detalhes/observações da coordenação, status de aprovação e exclusão de certificados vinculados à matrícula do estudante.
- **Notificações e Perfil:** Acompanhamento do retorno dos certificados enviados e visualização/edição dos dados do perfil do aluno.

---

## Stack e Versões Atualizadas

- **Flutter / Dart:** `sdk: ">=3.0.0 <4.0.0"` (validado em Flutter `3.50.0` / Dart `3.14.0`)
- **Android Build:**
  - Gradle `9.5.0` (Kotlin DSL: `settings.gradle.kts`, `build.gradle.kts`, `app/build.gradle.kts`)
  - Android Gradle Plugin (AGP) `9.3.1`
  - Kotlin `2.4.20` | Java `17`
  - Google Services Plugin `4.6.0`
- **Principais Dependências (`pubspec.yaml`):**
  - `firebase_core: ^5.1.0`, `firebase_auth: ^7.0.1`, `cloud_firestore: ^7.0.0`
  - `get: ^4.7.3`
  - `syncfusion_flutter_charts: ^35.1.46`
  - `percent_indicator: ^4.2.5`
  - `image_picker: ^1.1.2`

---

## Como Executar Localmente

### Pré-requisitos
- Flutter SDK instalado (compatível com Dart 3)
- Android Studio / Android SDK com emulador ou dispositivo físico configurado
- Conta/projeto no Firebase com **Authentication** (E-mail/Senha) e **Cloud Firestore** habilitados

### Passo a passo

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/Davi-PF/catolica_mhc.git
   cd catolica_mhc
   ```

2. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

3. **Configure o Firebase (caso utilize sua própria instância):**
   - Atualize `android/app/google-services.json` e `lib/firebase_options.dart` (por exemplo, via `flutterfire configure`).
   - Certifique-se de que as regras do Cloud Firestore permitam acesso às coleções `usuarios_mhc` e `certificados_mhc` para usuários autenticados.

4. **Execute o aplicativo:**
   ```bash
   flutter run
   ```

> **Nota sobre migração:** Não é mais necessário utilizar a flag `--no-sound-null-safety` nem fixar versões legadas do `get`, pois todo o código foi atualizado para Sound Null Safety e compatível com Dart 3.

---

## Principais Melhorias da Atualização (2026)

- Migração completa para **Dart 3 / Null Safety** e correção de todos os apontamentos do `dart analyze` (`flutter_lints`).
- Padronização de nomenclaturas de arquivos e identificadores em `snake_case` / `lowerCamelCase`.
- Migração dos scripts Android de Groovy para **Gradle Kotlin DSL (`.kts`)** e atualização de AGP/Gradle/Kotlin.
- Ajustes de responsividade nas telas de autenticação (fundo em tela cheia) e alinhamento/centralização do gráfico no Dashboard (`CircularChartAnnotation`).
