# Quiz App

Aplicativo mobile desenvolvido em Flutter como projeto teste da modalidade **#08 – Desenvolvimento de Aplicativos Móveis** (WorldSkills — Seletiva Estadual do Paraná), Módulo C.

## 📱 Sobre o projeto

Aplicativo de login com sistema de quizzes temáticos, recuperação de senha por pergunta secreta, bloqueio de tentativas de login e feedback animado de acerto/erro.

## 🖥️ Telas

- **Splash** — logo centralizada (até 60% da largura), barra de progresso sincronizada com os 3s de carregamento (0% → 100%), navegação automática para Login
- **Login** — autenticação local com base em tabela de usuários fixa, ícone de acesso à tela "Sobre", link "Esqueci minha senha"
  - Popup de erro diferenciado (ambos os campos incorretos vs. apenas senha incorreta)
  - Bloqueio de 15s após 3 tentativas com ambos os campos errados (com contador regressivo visível)
  - Bloqueio permanente (até reabrir o app) após 5 erros de senha, mas permitindo login de outro usuário válido
- **Recuperação de Senha** — validação por e-mail + resposta de pergunta secreta (case insensitive), seguida de tela de nova senha + confirmação, com mensagem de sucesso e redirecionamento automático (2s) para o Login
- **Home** — nome e foto do usuário, logo, logout, lista de quizzes disponíveis (título + data)
- **Respostas do Quiz** — uma questão por vez, 4 alternativas (radio buttons), botões "Responder" e "Pular", animação 2D de vitória (3s) ou erro (5s), resultado final em popup com percentual de acertos

## 👤 Usuários de teste

| Nome | E-mail | Senha | Pergunta |
|---|---|---|---|
| Aristóteles | ari_malvadao@exemplo.com | ariari | Qual a data de nascimento? |
| Frajola | frazinho_furacao@exemplo.com | frafra | Qual a raça de seu gato? |
| Canabrava | canabrava51@exemplo.com | cancan | Qual a cor da bebida preferida? |
| Arthurito | arturo@exemplo.com | artart | Qual a altura? |

## 🎨 Paleta de cores

| Cor | Hex |
|---|---|
| Fundo claro | `#F7F7F7` |
| Fundo secundário | `#EDEDED` |
| Azul escuro | `#003764` |
| Azul médio | `#0084AD` |
| Texto/escuro | `#333333` |

## ⚙️ Tecnologias

- Flutter
- Animações 2D de feedback (acerto/erro)
- Persistência local de acertos/pontuação por sessão de quiz

## 📦 Requisitos técnicos atendidos

- Telas em tela cheia, sem ícones padrão do sistema (Splash)
- Logo limitada a 20% da largura nos cabeçalhos, foto de usuário com cantos arredondados
- Alinhamento de texto justificado em todas as telas
- Ícone de aplicação customizado (escolhido no mediafiles)
- Bloqueio de todos os controles durante o cooldown de tentativas de login

## ▶️ Como executar

```bash
flutter pub get
flutter run
```

## 📝 Entrega

Desenvolvimento versionado via Git, com commits organizados por funcionalidade.
