class Nave {
  var velocidad = 0
  var direccion = 0
  var combustible = 0 

  method acelerar(cuanto) {
    velocidad = 100000.min(velocidad + cuanto)
  }

  method desacelerar(cuanto) {
    velocidad = 0.max(velocidad - cuanto)
  }

  method irHaciaElSol() {
    direccion = 10
  }

  method escaparDelSol() {
    direccion = -10
  }

  method ponerseParaleloAlSol() {
    direccion = 0
  }

  method acercarseUnPocoAlSol() {
    direccion = 10.min(direccion + 1)
  }

  method alejarseUnPocoDelSol() {
    direccion = (-10).max(direccion - 1)
  }

  method prepararViaje()

  method cargarCombustible(unaCantidad) {
    combustible += unaCantidad
  }

  method descargarCombustible(unaCantidad) {
    combustible = 0.max(combustible - unaCantidad)
  }

  method accionAdicionalAlViaje() {
    self.cargarCombustible(30000)
    self.acelerar(5000)
  }

  method estaTranquila() = combustible >= 4000 and velocidad <= 12000

  method recibirAmenaza() {
    self.escapar()
    self.avisar()
  }

  method escapar()

  method avisar()

  method relajo() = self.estaTranquila() and self.pocaActividad()

  method pocaActividad() 
}

class NaveBaliza inherits Nave {
  var colorBaliza = "verde"
  var cambioDeColor = false

  method cambiarColorDeBaliza(colorNuevo) {
    if(not ["verde","azul","rojo"].contains(colorNuevo))
        self.error("Color no permitido")
    colorBaliza = colorNuevo
    cambioDeColor = true
  }

  override method prepararViaje() {
    self.cambiarColorDeBaliza("verde")
    self.ponerseParaleloAlSol()
    self.accionAdicionalAlViaje()
  }

  override method estaTranquila() = super() and colorBaliza != "rojo"

  override method escapar() {
    self.irHaciaElSol()
  }

  override method avisar() {
    self.cambiarColorDeBaliza("rojo")
  }

  override method pocaActividad() = not cambioDeColor
}

class NavePasajero inherits Nave {
  var cantPasajeros = 0
  var racionesComida = 0
  var racionesBebida = 0
  var comidasServidas = 0

  method subirPasajeros(unaCantidad) {
    cantPasajeros = cantPasajeros + unaCantidad
  }

  method bajarPasajeros(unaCantidad) {
    cantPasajeros = 0.max(cantPasajeros - unaCantidad)
  }

  method cargarComida(unaCantidad) {
    racionesComida = racionesComida + unaCantidad
  }

  method cargarBebida(unaCantidad) {
    racionesBebida = racionesBebida + unaCantidad
  }

  method descargarComida(unaCantidad) {
    racionesComida 0.max(racionesComida - unaCantidad)
  }

  method descargarBebida(unaCantidad) {
    racionesBebida 0.max(racionesBebida - unaCantidad)
  }

  override method prepararViaje() {
    self.cargarComida(4 * cantPasajeros)
    self.cargarBebida(6 * cantPasajeros)
    self.acercarseUnPocoAlSol()
    self.accionAdicionalAlViaje()
  }

  override method escapar() {
    self.acelerar(velocidad)
  }

  override method avisar() {
    self.descargarComida(cantPasajeros)
    comidasServidas = cantPasajeros
    self.descargarBebida(cantPasajeros * 2)
  }

  override method pocaActividad() = comidasServidas >= 50
}

class NaveHospital inherits NavePasajero {
  var property prepararQuirofanos = false

  override method estaTranquila() = super() and not prepararQuirofanos

  override method recibirAmenaza() {
    super()
    prepararQuirofanos = true
  }
}

class NaveCombate inherits Nave {
  const property mensajesEmitidos = []
  var estaInvisible = false
  var misilesDesplegados = false

  method ponerseVisible() {
    estaInvisible = false
  }

  method ponerseInvisible() {
    estaInvisible = true
  }

  method estaInvisible() = estaInvisible

  method desplegarMisiles() {
    misilesDesplegados = true
  }

  method replegarMisiles() {
    misilesDesplegados = false
  }

  method misilesDesplegados() = misilesDesplegados

  method emitirMensaje(mensaje) {
    mensajesEmitidos.add(mensaje)
  }

  method primerMensajeEmitido() = mensajesEmitidos.first()

  method ultimoMensajeEmitido() = mensajesEmitidos.last()

  method esEscueta() = not mensajesEmitidos.any({m => m.size() > 30})
  //method esEscueta() = mensajesEmitidos.all({m => m.size() <= 30})

  method emitioMensaje(mensaje) = mensajesEmitidos.contains(mensaje)

  override method prepararViaje() {
    self.ponerseVisible()
    self.replegarMisiles()
    self.acelerar(15000)
    self.emitirMensaje("Saliendo en mision")
    self.accionAdicionalAlViaje()
  }

  override method accionAdicionalAlViaje() {
    super()
    self.acelerar(15000)
  }

  override method estaTranquila() = super() and not misilesDesplegados

  override method escapar() {
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
  }

  override method avisar() {
    self.emitirMensaje("Amenaza recibida")
  }
}

class NaveSigilosa inherits NaveCombate {
  override method estaTranquila() = super() and not estaInvisible

  override method escapar() {
    super()
    self.desplegarMisiles()
    self.ponerseInvisible()
  }
}