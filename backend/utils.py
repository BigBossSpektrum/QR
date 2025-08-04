import qrcode

def generar_qr(url_destino, path_salida):
    qr = qrcode.make(url_destino)
    qr.save(path_salida)