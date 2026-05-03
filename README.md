# 📡 GrK Radar — Sistema de Patrulha Minimalista

O **GrK Radar** é um sistema de monitoramento veicular frontal projetado para viaturas policiais. Com uma interface ultra-compacta e elegante, o script oferece aos oficiais a capacidade de identificar modelos e placas em tempo real, com alerta integrado para veículos com queixa de roubo.

## ✨ Funcionalidades

* **🖥️ Interface Minimalista**: Design focado na imersão, utilizando fontes limpas e uma representação visual de placas no padrão Mercosul.
* **🕵️ Alerta de Roubo Nativo**: Integração direta com o `GlobalState.StolenPlates`. O radar identifica automaticamente veículos marcados como roubados através do sistema **Gov.xp**.
* **❄️ Função Freeze**: Permite travar a leitura atual para consulta manual de dados, evitando que a placa mude ao passar por outros veículos.
* **✥ Sistema de Arraste (Drag)**: Interface totalmente móvel. Use o comando `/radar` para reposicionar o display em qualquer lugar da tela.
* **🚀 Alta Performance**: Otimizado para rodar com baixo consumo (resmon), ativando as verificações apenas quando o oficial está em serviço e dentro de uma viatura.

## 📦 Dependências

Para garantir o funcionamento de todos os módulos, certifique-se de ter:

1.  **vRP** (Framework base).
2.  **PolyZone** (Para detecção de zonas, se aplicável).
3.  **[Gov.xp](https://github.com/gregodeveloper/app-gov-lb-phone)** (Recomendado para o funcionamento do alerta de roubo).

## 🚀 Instalação

1.  Crie uma pasta chamada `grk_radar` no seu diretório de `resources`.
2.  Mova os arquivos `client-side`, `web-side` e o `fxmanifest.lua` para dentro dela.
3.  Certifique-se de que a imagem da placa (`plate02.png`) está acessível através da URL configurada no `css.css`.
4.  Adicione `ensure grk_radar` ao seu arquivo `server.cfg`.

## 🎮 Comandos e Atalhos

* **Tecla [N]**: Liga e desliga o sistema de radar.
* **Tecla [M]**: Trava (Freeze) ou destrava a leitura da placa atual.
* **Comando `/radar`**: Entra no modo de edição para mover a interface pela tela.
* **Tecla [ESC]**: Salva a posição e sai do modo de edição.

## ⚙️ Detalhes de Integração

O radar monitora o estado global do servidor para identificar crimes. No seu script de despacho ou no **Gov.xp**, ao registrar um roubo, basta atualizar a tabela global:

```lua
-- Exemplo de ativação de alerta para o radar
local plates = GlobalState.StolenPlates or {}
plates["ABC1D23"] = true
GlobalState.StolenPlates = plates
🛠️ Desenvolvido por GrK Development • Inovação para o seu Servidor
