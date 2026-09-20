package cl.ipchile.educaparatodos.modelo;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OrderBy;
import jakarta.persistence.Table;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "curso")
public class Curso {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_curso")
    private Long id;

    @Column(nullable = false, length = 150)
    private String titulo;

    @Column(nullable = false)
    private String descripcion;

    @Column(nullable = false, length = 80)
    private String tema;

    @Column(nullable = false, length = 30)
    private String nivel;

    @Column(name = "fecha_publicacion", nullable = false)
    private LocalDate fechaPublicacion;

    @Column(nullable = false)
    private boolean activo;

    @OneToMany(mappedBy = "curso")
    @OrderBy("orden ASC")
    private List<Leccion> lecciones = new ArrayList<>();

    @OneToMany(mappedBy = "curso")
    private List<Inscripcion> inscripciones = new ArrayList<>();

    protected Curso() {
    }

    public Curso(String titulo, String descripcion, String tema, String nivel,
                 LocalDate fechaPublicacion) {
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.tema = tema;
        this.nivel = nivel;
        this.fechaPublicacion = fechaPublicacion;
        this.activo = true;
    }

    public Long getId() {
        return id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getTema() {
        return tema;
    }

    public void setTema(String tema) {
        this.tema = tema;
    }

    public String getNivel() {
        return nivel;
    }

    public LocalDate getFechaPublicacion() {
        return fechaPublicacion;
    }

    public boolean isActivo() {
        return activo;
    }

    public void setActivo(boolean activo) {
        this.activo = activo;
    }

    public List<Leccion> getLecciones() {
        return lecciones;
    }

    public List<Inscripcion> getInscripciones() {
        return inscripciones;
    }
}
