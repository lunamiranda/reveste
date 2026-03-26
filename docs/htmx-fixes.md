# ReVeste - HTMX SPA Fixes

## Problemas Resolvidos

### 1. CSS @import Ignorado

**Sintoma:** Console do navegador indicava que uma regra `@import` foi ignorada no arquivo styles.css porque não estava no topo do arquivo.

**Causa:** O `@import` das fontes estava na linha 826 do arquivo CSS, após várias regras CSS.

**Solução:** Movemos o `@import` para o topo absoluto do arquivo CSS.

```css
/* styles.css - Linha 1-4 */
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,700;0,900;1,700&display=swap');
```

### 2. Servidor binding em 127.0.0.1

**Sintoma:** Kamal mostrava "First web container is unhealthy" durante o deploy.

**Causa:** O servidor Zig estava bindando em `127.0.0.1` (apenas localhost), mas o Kamal/Traefik precisa acessar via IP do container.

**Solução:** Alteramos o bind de `127.0.0.1` para `0.0.0.0` em `src/main.zig`:

```zig
const server = try spider.Spider.init(arena, io, "0.0.0.0", 8081, .{
    .layout = @embedFile("views/layout.html"),
});
```

### 3. HTMX - Perda de Estilo ao Navegar

**Sintoma:** Site abria normal, mas ao clicar em várias páginas, o estilo desaparecia.

**Causa:** O site usava navegação HTML normal (full page reload), não aproveitando o HTMX para SPA.

**Solução:** Adicionamos navegação HTMX com as seguintes atributos em todos os links do nav:

```html
<a href="/" hx-get="/" hx-target="#main" hx-push-url="true" hx-select="#main">Início</a>
```

**Mudanças no layout.html:**
- `<main id="main">` envolveu o conteúdo para ser o alvo do HTMX
- Links do nav получили atributos HTMX
- `htmx:afterSwap` atualiza o estado "active" do nav

### 4. HTMX Partial Rendering via Proxy

**Sintoma:** Ao navegar via HTMX através do proxy (Kamal/Traefik), a página inteira era injetada ao invés do conteúdo parcial.

**Causa:** O proxy reverso não passava o header `HX-Request` para o backend, impossibilitando renderização parcial server-side.

**Solução:** Usar `hx-select="#main"` no client-side para extrair apenas o conteúdo desejado:

```html
<a hx-get="/problema" hx-target="#main" hx-push-url="true" hx-select="#main">Problema</a>
```

**Vantagens:**
- Não precisa de configuração no Traefik
- Funciona independente do proxy reverso
- Compatible com qualquer ambiente (Cloudflare, nginx, etc)

### 5. Menu Mobile Não Fechava

**Sintoma:** No mobile, ao clicar em um link do menu, a página mudava mas o menu permanecia aberto.

**Solução:** Adicionamos lógica no `htmx:afterSwap` para fechar o menu automaticamente:

```javascript
document.body.addEventListener('htmx:afterSwap', function(evt) {
  // Close mobile menu on navigation
  if (navLinks) {
    navLinks.classList.remove('open');
  }
  // Update active nav link
  // ...
});
```

## Commits

- `a3b374f` - fix: move @import to top of CSS file
- `3231f1d` - up (IP binding fix)
- `530b699` - feat: add HTMX SPA navigation with smooth transitions
- `c115058` - fix: add hx-select to prevent full page injection via proxy
- `ce39518` - fix: close mobile menu on HTMX navigation