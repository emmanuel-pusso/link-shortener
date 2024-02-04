# CREATE 2 USERS

user1 = User.create(username: "epusso", email: "epusso@gmail.com", password: "123456")
user2 = User.create(username: "nramirez", email: "nramirez@gmail.com", password: "654321")

# CREATE LINKS FOR user1
link1 = LinkRegular.create(user_id: user1.id, name:"LinkWithReports", large_url: "https://www.info.unlp.edu.ar/acceso-alumnos/tren-universitario-articulo/", slug:"FTI7VT", type: "LinkRegular")
LinkRegular.create(user_id: user1.id, name:"LinkRegularB", large_url: "https://www.info.unlp.edu.ar/ingreso-2024-inscripcion-para-estudiar-en-informatica/", slug:"X0KK0E", type: "LinkRegular")
LinkEphemeral.create(user_id: user1.id, name:"LinkVisited", large_url: "https://www.info.unlp.edu.ar/acceso-alumnos/", slug:"7KTVFH", visited: true, type: "LinkEphemeral")
LinkEphemeral.create(user_id: user1.id, name:"LinkNotVisited", large_url: "https://www.info.unlp.edu.ar/graduados-de-informatica-fueron-reconocidos-por-la-unlp-3/", slug:"CELYBA", visited: false, type: "LinkEphemeral")
LinkTemporal.create(user_id: user1.id, name:"LinkNotExpired", large_url: "https://www.info.unlp.edu.ar/licenciatura-en-informatica-plan-2021/", slug:"QYDL3P", expires_at: DateTime.current + 1.day, type: "LinkTemporal")
LinkPrivate.create(user_id: user1.id, name:"LinkPrivate", large_url: "https://www.info.unlp.edu.ar/ingreso-2024-inscripcion-para-estudiar-en-informatica/", slug:"Jq3R7z", secret: "Password123!", type: "LinkPrivate")

# CREATE LINKS FOR user2
LinkPrivate.create(user_id: user2.id, name:"LinkPrivate2", large_url: "https://www.info.unlp.edu.ar/curso-de-verano-2024/", slug:"W7zp1A", secret: "Password123!!", type: "LinkPrivate")
LinkTemporal.create(user_id: user2.id, name:"LinkExpiredNext1Day", large_url: "https://www.info.unlp.edu.ar/analista-programador-universitario/", slug:"qY96zK", expires_at: DateTime.current + 1.day, type: "LinkTemporal")
LinkTemporal.create(user_id: user2.id, name:"LinkExpiredNext1Hour", large_url: "http://www.cinemacenter.com.ar", slug:"qY0zS2", expires_at: DateTime.current + 1.hour, type: "LinkTemporal")
LinkTemporal.create(user_id: user2.id, name:"LinkExpiredNext5Minutes", large_url: "https://www.info.unlp.edu.ar/analista-programador-universitario/", slug:"YR1x5w", expires_at: DateTime.current + 5.minutes, type: "LinkTemporal")


# GENERATE VISITS FOR link1 BELONGS TO user1

# generate 10 visits (from an initial day, 1 visit per day is generated, with different ip_address)
initial_ip = '192.168.0.1'
initial_date = Date.new(2023, 9, 25)
(0..9).each do |i|
  ip_address = "#{initial_ip[0..-2]}#{i}"
  Link.find_by(slug: link1.slug).visits.create(visited_at: initial_date, ip_address: ip_address)
  initial_date += 1.day
end

# generate 6 visits (on the same day, with different ip_address)
initial_ip = '192.168.1.0'
(0..5).each do |i|
  ip_address = "#{initial_ip[0..-2]}#{i}"
  Link.find_by(slug: link1.slug).visits.create(visited_at: Date.new(2023, 10, 13), ip_address: ip_address)
end

# generate 8 visits (on different days, with same ip_address)
initial_date = Date.new(2023, 11, 03)
(0..7).each do |i|
  ip_address = "#{initial_ip[0..-2]}#{i}"
  Link.find_by(slug: link1.slug).visits.create(visited_at: initial_date, ip_address: '192.168.2.3')
  initial_date += 1.day
end

# generate 7 visits (on the same day, with same ip_address)
(0..6).each do |i|
  Link.find_by(slug: link1.slug).visits.create(visited_at: Date.today - 5, ip_address: '192.173.1.2')
end
