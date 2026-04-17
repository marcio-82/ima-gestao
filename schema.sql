-- IMA Lda — Schema da base de dados
-- Corre este SQL no Supabase → SQL Editor → New Query

-- Tabela de perfis de utilizadores
create table if not exists public.profiles (
  id uuid references auth.users on delete cascade primary key,
  nome text not null,
  cargo text,
  role text default 'colaborador', -- 'gestor' ou 'colaborador'
  avatar text,
  created_at timestamptz default now()
);

-- Tabela de tickets/problemas
create table if not exists public.tickets (
  id bigserial primary key,
  titulo text not null,
  descricao text,
  prioridade text default 'medio', -- baixo, medio, alto, urgente
  estado text default 'aberto',    -- aberto, em-curso, resolvido, fechado
  categoria text,                  -- Manutenção, Comercial, Administrativo, Logística
  responsavel_id uuid references public.profiles(id),
  criado_por uuid references public.profiles(id),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Tabela de mensagens dos tickets
create table if not exists public.mensagens_ticket (
  id bigserial primary key,
  ticket_id bigint references public.tickets(id) on delete cascade,
  autor_id uuid references public.profiles(id),
  texto text not null,
  created_at timestamptz default now()
);

-- Tabela de mensagens gerais (canal da equipa)
create table if not exists public.mensagens_gerais (
  id bigserial primary key,
  autor_id uuid references public.profiles(id),
  texto text not null,
  created_at timestamptz default now()
);

-- Row Level Security
alter table public.profiles enable row level security;
alter table public.tickets enable row level security;
alter table public.mensagens_ticket enable row level security;
alter table public.mensagens_gerais enable row level security;

-- Políticas: utilizadores autenticados podem ler tudo
create policy "Leitura autenticada" on public.profiles for select using (auth.role() = 'authenticated');
create policy "Leitura autenticada" on public.tickets for select using (auth.role() = 'authenticated');
create policy "Leitura autenticada" on public.mensagens_ticket for select using (auth.role() = 'authenticated');
create policy "Leitura autenticada" on public.mensagens_gerais for select using (auth.role() = 'authenticated');

-- Políticas de escrita
create policy "Inserir autenticado" on public.tickets for insert with check (auth.role() = 'authenticated');
create policy "Atualizar autenticado" on public.tickets for update using (auth.role() = 'authenticated');
create policy "Inserir mensagem ticket" on public.mensagens_ticket for insert with check (auth.role() = 'authenticated');
create policy "Inserir mensagem geral" on public.mensagens_gerais for insert with check (auth.role() = 'authenticated');
create policy "Inserir perfil" on public.profiles for insert with check (auth.uid() = id);
create policy "Atualizar perfil" on public.profiles for update using (auth.uid() = id);

-- Trigger para updated_at nos tickets
create or replace function update_updated_at()
returns trigger as $$
begin new.updated_at = now(); return new; end;
$$ language plpgsql;

create trigger tickets_updated_at before update on public.tickets
for each row execute function update_updated_at();

-- Trigger para criar perfil automaticamente ao registar
create or replace function handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, nome, cargo, role)
  values (new.id, coalesce(new.raw_user_meta_data->>'nome', split_part(new.email, '@', 1)), new.raw_user_meta_data->>'cargo', coalesce(new.raw_user_meta_data->>'role', 'colaborador'));
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created after insert on auth.users
for each row execute function handle_new_user();
