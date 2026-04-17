# IMA Lda — Gestão de Problemas

Aplicação web para gestão de problemas e comunicação interna da equipa IMA Lda.

---

## PASSO 1 — Configurar a base de dados (Supabase)

1. Vai a https://supabase.com e entra na tua conta
2. Abre o teu projeto "ima-gestao"
3. No menu da esquerda clica em **SQL Editor**
4. Clica em **New Query**
5. Abre o ficheiro `schema.sql` (está na pasta que descarregaste)
6. Copia todo o conteúdo e cola no editor do Supabase
7. Clica em **Run** (botão verde)
8. Deve aparecer "Success" — a base de dados está pronta!

---

## PASSO 2 — Registar os utilizadores (Supabase Auth)

1. No Supabase, vai a **Authentication → Users**
2. Clica em **Add User** para cada membro da equipa:

| Nome | Email | Password inicial |
|------|-------|-----------------|
| Marcio | marcio@ima.pt | (define tu) |
| Filipe | filipe@ima.pt | (define tu) |
| Emanuel | emanuel@ima.pt | (define tu) |
| Ricardo | ricardo@ima.pt | (define tu) |

3. Depois de criar cada utilizador, vai ao **SQL Editor** e corre:

```sql
UPDATE public.profiles SET cargo = 'Financeiro' WHERE id = (SELECT id FROM auth.users WHERE email = 'filipe@ima.pt');
UPDATE public.profiles SET cargo = 'Aux. Adm. Grill & Gelo' WHERE id = (SELECT id FROM auth.users WHERE email = 'emanuel@ima.pt');
UPDATE public.profiles SET cargo = 'Aux. Gelo & Manutenção' WHERE id = (SELECT id FROM auth.users WHERE email = 'ricardo@ima.pt');
UPDATE public.profiles SET cargo = 'Diretor Geral', role = 'gestor' WHERE id = (SELECT id FROM auth.users WHERE email = 'marcio@ima.pt');
```

---

## PASSO 3 — Publicar online (Vercel)

### 3a. Colocar o código no GitHub
1. Vai a https://github.com e cria conta (se não tens)
2. Clica em **New repository**
3. Nome: `ima-gestao` — clica **Create repository**
4. Faz upload de todos os ficheiros da pasta `ima-gestao`

### 3b. Publicar no Vercel
1. Vai a https://vercel.com e cria conta com o teu GitHub
2. Clica em **Add New Project**
3. Seleciona o repositório `ima-gestao`
4. Clica em **Deploy**
5. Em 1 minuto o site fica online!

O link será algo como: **https://ima-gestao.vercel.app**

---

## Como usar

### Como gestor (Marcio)
- Vês **todos os problemas** de toda a equipa
- Podes **atribuir responsável** ao criar um problema
- Podes **mudar o estado** de qualquer problema
- Tens acesso à aba **Equipa** para ver o resumo de cada colaborador

### Como colaborador (Filipe, Emanuel, Ricardo)
- Vês os **teus problemas** (criados por ti ou atribuídos a ti)
- Podes **registar novos problemas**
- Podes **adicionar atualizações** (mensagens) em cada problema
- Tens acesso ao **canal geral** da equipa

---

## Suporte

Aplicação desenvolvida com:
- **Supabase** — base de dados e autenticação (grátis)
- **Vercel** — hospedagem (grátis)
- Funciona em telemóvel e computador
