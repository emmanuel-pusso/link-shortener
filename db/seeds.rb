# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user = User.create(username: "epusso", email: "emmanuel.pusso@gmail.com", password: "12345")

LinkRegular.create(user_id: user.id, name:"LinkRegularA", large_url: "https://www.info.unlp.edu.ar/acceso-alumnos/tren-universitario-articulo/", slug:"FTI7VT", type: "LinkRegular")
LinkRegular.create(user_id: user.id, name:"LinkRegularB", large_url: "https://www.info.unlp.edu.ar/ingreso-2024-inscripcion-para-estudiar-en-informatica/", slug:"X0KK0E", type: "LinkRegular")
LinkEphemeral.create(user_id: user.id, name:"LinkVisited", large_url: "https://www.info.unlp.edu.ar/acceso-alumnos/", slug:"7KTVFH", visited: true, type: "LinkEphemeral")
LinkEphemeral.create(user_id: user.id, name:"LinkNotVisited", large_url: "https://www.info.unlp.edu.ar/graduados-de-informatica-fueron-reconocidos-por-la-unlp-3/", slug:"CELYBA", visited: false, type: "LinkEphemeral")
LinkTemporal.create(user_id: user.id, name:"LinkExpired", large_url: "https://www.info.unlp.edu.ar/licenciatura-en-informatica-plan-2021/", slug:"R8RVL5", expires_at: "2023-12-11T20:30", type: "LinkTemporal")
LinkTemporal.create(user_id: user.id, name:"LinkNotExpired", large_url: "https://www.info.unlp.edu.ar/licenciatura-en-informatica-plan-2021/", slug:"QYDL3P", expires_at: "2023-12-30T09:15", type: "LinkTemporal")
