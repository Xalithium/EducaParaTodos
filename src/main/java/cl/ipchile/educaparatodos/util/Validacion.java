package cl.ipchile.educaparatodos.util;

import java.util.Locale;


public class Validacion {
    public static String texto(String valor, String campo, int maximo) {
        if (valor == null || valor.isBlank()) throw new IllegalArgumentException("Completa el campo " + campo + ".");
        valor = valor.strip();
        if (valor.length() > maximo) throw new IllegalArgumentException(campo + " permite hasta " + maximo + " caracteres.");
        return valor;
    }
    public static String correo(String valor) {
        valor = texto(valor, "correo", 150).toLowerCase(Locale.ROOT);
        if (!valor.matches("[^\\s@]+@[^\\s@]+[.][^\\s@]+")) throw new IllegalArgumentException("Escribe un correo válido, por ejemplo nombre@correo.cl.");
        return valor;
    }
    public static String nivel(String valor) {
        if (!java.util.List.of("Básico", "Intermedio", "Avanzado").contains(valor == null ? "" : valor)) {
            throw new IllegalArgumentException("Selecciona un nivel válido.");
        }
        return valor;
    }
}