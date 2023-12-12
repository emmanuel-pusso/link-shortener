# README

Este repo contiene el código para el Trabajo Final Integrador de la materia
**"Taller de Tecnologías de Producción de Software ‑ Ruby"** _(Cursada 2023)_

## Contexto
Estás a cargo del desarrollo de una aplicación de generación y gestión de links cortos, al estilo de Bitly,
T.ly, o TinyURL. El objetivo de esta aplicación web es brindar links cortos para URLs arbitrariamente
largas, que puedan ser utilizados en redes sociales o cualquier comunicación online para compartir
páginas web de manera sencilla.

## Requisitos técnicos
El desarrollo debe realizarse utilizando el siguiente stack tecnológico:
- Una versión reciente de Ruby (2.7 o superior).
- La versión estable más reciente del framework Ruby on Rails (7.1.2 al momento de escribir
este documento).
- Una base de datos SQLite para dar soporte de persistencia.

## Pasos para correr la aplicación

1. Disponer de los requisitos técnicos arriba mencionados
2. Clonarse el repo
3. Abrir la aplicación de Rails, y en una Terminal ejecutar los siguientes comandos:
  - _Instalar gemas:_ `bundle install`
  - _Crear BD y correr migraciones:_ `rails db:create db:migrate`
  - _Para cargar las BD:_ `rails db:seeds`
  - _Para levantar la aplicación:_ `rails server`
  - _Abrir el browser y navegar a la url:_ http://localhost:3000/links

## Decisiones de diseño

Para generar el slug único se uso la gema [securerandom](https://github.com/ruby/securerandom)

Para validar el formato de los links se uso una expresión regular.

El patrón de URL a utilizar es 
http://localhost:3000/l/:slug

***Por ejemplo:*** localhost:3000/l/FTI7VT

Para modelar la jerarquía de Links en el modelo se uso el patrón **Single Table Inheritance**. 
En Base de Datos solo existe la tabla **"links"** que distingue entre los diferentes tipos (LinkRegular, LinkEphemeral, LinkTemporal, LinkPrivate) por el el atributo "type".

Se utiliza el mismo controlador para los diferentes tipos de Links, y se re-utiliza la misma vista.

Se genero la ruta
`get '/l/:slug', to: 'links#redirect_to_large_url'`

Donde se reutiliza el controlador de links, y se creo una nueva acción ***"redirect_to_large_url"*** que resuelve la lógica del trabajo.

## Que incluye está entrega:
- CRUD de Links para los tipos: LinkRegular, LinkEphemeral, LinkTemporal
- Lógica de generación y asignación automática de Slug
- Comprobación de si el link puede ser accedido, delegada en el modelo de cada tipo de LINK
- Para los links efímeros una vez que fue visitado se setea visited = true, y la próxima vez que se quiera acceder retorna un código de respuesta HTTP 403 Forbidden
- Como aún no se implemento la parte de autenticación la asignación de links está harcodeada, para que TODOS los links se asocien al User con **id:1**

## Cosas pendientes
- Autenticación y registración de usuarios (se utilizará la gema [devise](https://github.com/heartcombo/devise))
- Lógica para LinkPrivate (que requieren de una clave para acceder)
- Logica de registrar las visitas a los Links (fecha, hora, IP)
- Reportes de visitas, con opción de filtrado/búsqueda por rango de fechas o IP
- Mejorar la estética de la aplicación con agregado de css y código javascript
  

