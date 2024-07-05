class Imagen {
  int ?id;
  String ?nombre;
  String ?imagen;
  String ?estado;

  Imagen(
      {this.id,
        this.nombre,
        this.imagen,
        this.estado});

  factory Imagen.fromJson(Map<String, dynamic> parsedJson) {
    return Imagen(
        id: parsedJson['id'],
        nombre: parsedJson['nombre'],
        imagen: parsedJson['imagen'],
        estado: parsedJson['estado']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['nombre'] = nombre;
    data['imagen'] = imagen;
    data['estado'] = estado;
    return data;
  }
}
