# App Carrinho de Compras

App Flutter de carrinho de compras em **MVVM**, com tema brutalista (bordas marcantes, azul e vermelho). Suporta Android e iOS.

## Requisitos

- **Flutter** 3.x
- **Dart** 3.10+
- Android Studio / Xcode (para emuladores)

## Como rodar

```bash
# Instalar dependências
flutter pub get

# Rodar no dispositivo/emulador
flutter run
```

## Build

```bash
# Android
flutter build apk

# iOS
flutter build ios
```

## Arquitetura

O app segue o padrão **MVVM** com separação clara de responsabilidades:

```
lib/
├── core/                    # Infraestrutura compartilhada
│   ├── result/              # Result<T> (Success/Failure) para operações assíncronas
│   ├── routes/              # Rotas nomeadas
│   └── theme/               # Cores, tipografia, tema brutalista
├── shared/                  # Componentes e helpers reutilizáveis
│   ├── helpers/             # SnackBarHelper, etc.
│   └── widgets/             # AppButton, ProductCard, CartItemTile, etc.
├── data/                    # Camada de dados
│   ├── dtos/                # ProductDto
│   └── services/            # ProductsApi, CartApi, CheckoutApi, CepStorage
├── domain/                  # Regras de negócio
│   ├── models/              # Product, CartItem, Cart
│   └── cart_store.dart      # Estado global do carrinho (ChangeNotifier)
├── presentation/            # Telas e ViewModels
│   ├── catalog/
│   ├── cart/
│   ├── checkout_animation/
│   └── order_complete/
```

### Fluxo de dados

- **CartStore**: fonte única de verdade do carrinho. Não depende de API; a orquestração é feita no ViewModel.
- **ViewModels**: consomem APIs (ProductsApi, CartApi, CheckoutApi), tratam Result e atualizam o CartStore.
- **View**: observa `Consumer`/`Provider` e reage às mudanças.

### Padrão Command/Result

Todas as operações assíncronas retornam `Result<T>`:

- `Success(data)` — operação bem-sucedida
- `Failure(error)` — mensagem de erro para o usuário

O ViewModel converte para exceções ou estados, e a View exibe SnackBars/erros de forma padronizada via `SnackBarHelper`.

### Regras de negócio

- Máximo de 10 produtos distintos no carrinho
- Carrinho não é editável após finalização
- Edição de quantidade apenas no catálogo; no carrinho a lista é somente leitura

### Tema brutalista

- Bordas: `BorderSide(width: 2.0)`
- Cores: azul (#093578), vermelho (#900000), ciano (#00A0A3)
- Contraste forte entre fundos e bordas
