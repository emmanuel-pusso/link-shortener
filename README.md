# README

Este repo contiene el código para el Trabajo Final Integrador de la materia
**"Taller de Tecnologías de Producción de Software ‑ Ruby"** _(Cursada 2023)_

# Menu

- [Contexto](#contexto)
- [Requisitos técnicos](#requisitos-técnicos)
- [Pasos para correr la aplicación](#pasos-para-correr-la-aplicación)
- [Decisiones de diseño](#decisiones-de-diseño)
- [Entrega #1](#entrega-1)
- [Entrega #2 (final)](#entrega-2-final)

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
  - _Para cargar las BD:_ `rails db:seed`
  - _Para levantar la aplicación:_ `rails server`
  - _Abrir el browser y navegar a la url:_ http://localhost:3000/

## Decisiones de diseño
Para el desarrollo del trabajo se utilizo el **framework de Rails**; y los siguientes **patrones de arquitectura**:
- MVC (Model-View-Controller).
- Active Record
- Single Table Inheritance

Se implementaron callbacks (o hooks) y se integraron gemas según las necesidades específicas, capitalizando las funcionalidades inherentes del framework para evitar redundancias en el desarrollo.

Para modelar la jerarquía de Links en el modelo se uso el patrón **Single Table Inheritance**. 
En Base de Datos solo existe la tabla **"links"** que distingue entre los diferentes tipos (LinkRegular, LinkEphemeral, LinkTemporal, LinkPrivate) por el el atributo "type".

Se utiliza el mismo controlador para los diferentes tipos de Links "LinksController", y se re-utiliza la misma vista para creación, mostrando los campos de acuerdo al tipo de link que se quiera crear.

El patrón de URL a utilizar para el formato de links cortos es
http://localhost:3000/l/:slug

***Por ejemplo:*** localhost:3000/l/FTI7VT

Para ello se genero la ruta
`get '/l/:slug', to: 'links#redirect_to_large_url'`

Donde se reutiliza el controlador de links, y se creo una nueva acción ***"redirect_to_large_url"*** que resuelve la lógica del trabajo.

Para LinkPrivate se creo una **nueva vista** *"private.html.erb"* (donde el usuario ingresa el password) y una **nueva acción** *"redirect_to_large_url_for_private_link"* a donde es redirigido luego del submit (POST) del form.
Se presentaron problemas en la redirección del LinkPrivate (luego de ingresar el password y hacer el submit del form), tiraba errores por consola:
- OPTIONS CORS Missing Allow Origin
- GET NS_ERROR_DOM_BAD_URI
  
Para solucionarlo tuve que remover la gema turbo-rails del gemfile.

Para generar el slug único se uso la gema [securerandom](https://github.com/ruby/securerandom), que permite generar un código alfanumérico único de 6 caracteres sensible a mayúsculas y minúsculas.

Dentro del framework Rails, se utilizaron "scopes", que ayudan a escribir consultas de base de datos de manera más eficiente y legible.
Estos métodos que se definen en los modelos, encapsulan consultas comunes o complejas a la base de datos, y **pueden ser encadenados y combinados con otros métodos de consulta para refinar aún más los resultados. 
Los scopes fueran aplicados sobre el modelo **Visita**, para generar las queries que luego se van a utilizar al generar los reportes.
De esta manera se mantiene la lógica de búsquedas en el modelo, y queda más limpio el código en el controller.

Para la autenticación y registración de usuarios se utilizo la gema [devise](https://github.com/heartcombo/devise).
Tuve que personalizar la vista y el controlador para que admita el campo "username". 
Se redefinió la acción CREATE que hereda el comportamiento del controller original de devise, pero customiza la parte del nuevo campo (username).

## Entrega #1
- CRUD de Links para los tipos: LinkRegular, LinkEphemeral, LinkTemporal
- Lógica de generación y asignación automática de Slug
- Comprobación de si el link puede ser accedido, delegada en el modelo de cada tipo de LINK
- Para **LinkEphemeral** una vez que fue visitado se setea visited = true, y la próxima vez que se quiera acceder retorna un código de respuesta **HTTP 403 Forbidden**
- Para **LinkTemporal** una vez que fue expires_at está en el pasado, la próxima vez que se quiera acceder retorna un código de respuesta **HTTP 404 Not Found**
- Como aún no se implemento la parte de autenticación la asignación de links está harcodeada, para que TODOS los links se asocien al User con **id:1**

## Entrega #2 (final)
- Correciones Parte#1
	- Correción y simplicación de rutas para Links
	- Uso de callback (hooks) 
		- para asignar el slug (generado automáticamente) a un Link
		- para setear el link a partir del parámetro de la url :id
		- para setear el link a partir del parámetro de la url :slug
	- Refactor del código de creación de Link
		- Previamente se selecciona el tipo de Link, y solo se cargan los campos que correspondan para ese tipo
- Autenticación y registración de usuarios
- Cada usuario crea sus propios links
- Redireccion a Not Found cuando el :id o :slug (como parámetro en la URL) es inexistente
- Redirección a Access Denied page cuando se quiere acceder por :id o :slug (como parámetro en la URL) a un Link que NO tengo permiso (es de otro usuario). 
- Lógica para LinkPrivate (que requieren de una clave para acceder)
- Logica de registrar las visitas a los Links (fecha, IP)
- Se permite editar un LinkEphemeral reiniciando el valor de visited (si así lo quisiera)
- Reportes de visitas, con opción de filtrado/búsqueda por rango de fechas o IP
    - Permite búsquedas solo por IP, incluso IP parcial
    - Pemite búsqueda por fecha: From, To, From - To
    - Permite bíúsqueda por ambos criterios rango de fechas & IP
- Uso de scopes en el modelo de Visit, para realizar las queries que luego se van a utilizar en el controller para generar los reportes

  

