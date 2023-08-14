# CEP API

Esta aplicação é uma API de exemplo de solução para o desavio proposto pela Smart Software foi feilta em Ruby on Rails.
Ao invés fazer a serialização usando o padrão do Rails ou uma Gem, preferi fazer "na mão", para poder ter mais controler de como isso seria feito e melhoria nas funcionalidades que poderia disponibilizar.
Todas os resultados serializados são cacheados por padrão e podem ser paginados.

## Requisitos
* Ruby 3.1.3
* Rails 7.0.6
* SQLite3 1.4
* ... e outras Gems

## Instalação

```
git clone
cd cep-api
docker-compose build
```

## Executar Aplicação

Na pasta do projeto execute:

```
docker-compose up
```

Se for a primeira execução, abre uma nova janela de termina e execute:

```
docker-compose exec app /app/bin/rails db:create
docker-compose exec app /app/bin/rails db:migrate
docker-compose exec app /app/bin/rails db:seed
```
A Api está pronta para ser usada, por padrão na porta 3000.

## Usar a API

### Autenticação

A segurança de acesso a API é feita por uma API Key e um token
quando for necessário saber quem está acessando.
Para acessar os end points da API é necessário criar um token, dessa forma:

```
curl --location 'localhost:3000/api/v1/access_tokens' \
--header 'Content-Type: application/json' \
--header 'Authorization: CepApi-Token api_key=1:zip_api_key' \
--data-raw '{
    "data": {
        "email": "admin@email.com",
        "password": "password"
    }
}'
```

Para autenticar você precisa passar uma Api Key no header:
```
Authorization: CepApi-Token api_key=1:zip_api_key
```

Onde:
 * CepApi-Token é o Realm padrão da API
 * zip_api_key é key padrão criada pelo seed

Na resposta da requisição você vai receber um json com o token para este usuário

### Consultar CEP

```
/api/v1/zip_accesses/:id
```

Para consultar os dados de um determinado CEP execute:

```
curl --location 'localhost:3000/api/v1/zip_accesses/74590690' \
--header 'Authorization: CepApi-Token api_key=1:zip_api_key,access_token=1:token_gerado_na_autenicação'
```

Para autenticar além de passar a api_key, vc deve passar o token gerando na autenicação no campo access_token.

Como resposta você vai recer um JSON com os dados do CEP se existir ou uma mensagem de erro, caso não exista.

### Consultar endereços consultados

```
/api/v1/zip_accesses/
```

Para consultar os endereços dos CEPs consultados na API

```
curl --location 'localhost:3000/api/v1/zip_accesses/' \
--header 'Authorization: CepApi-Token api_key=1:zip_api_key,access_token=1:token_gerado_na_autenicação'
```

A API permite a inclusão dos dados do usuário que fez a consulta aos CEPs, para isto basta incluir ?embed=user na url:

```
/api/v1/zip_accesses/?embed=user
```

A API permite fazer vários tipos de filtros, como por exemplo para mostar as consultas ao bairros iniciados com Jardim:

```
/api/v1/zip_accesses/?q[neighborhood_start]=Jardim
```
Você pode fazer outros tipos de filtros:

* eq: valor do campo é igual a X (correspondência exata).
* cont: o valor do campo contém X.
* notcont: o valor do campo não contém X.
* start: o valor do campo começa com X.
* end: o valor do campo termina com X.
* gt: o valor do campo é maior que X. (gt = sinal de maior que '>')
* lt: o valor do campo é menor que X. (lt = sinal de menor que '<')

E também pode ordernar as resposta por qualquer campo e direção:

```
/api/v1/zip_accesses/?sort=neighborhood&dir=desc
```

Para paginar o resultado basta informar os parâmetros page e per (page):

```
/api/v1/zip_accesses/?page=2&per=3
```