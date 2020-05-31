# Práctica de UI Avanzada

## Objetivos

- Partiendo de la práctica realizada en el módulo de *Concurrencia y Red*, aplicar el nuevo diseño realizado en **Sketch** y su posterior exportación a **Zeplin**.

## Extra

- Refactorizada la vista Tema aplicando **MVVM**. El resto de la aplicación mantiene el patrón **MVC**.
- Añadida vista Ajustes para que el usuario eliga entre zurdo/diestro, de modo que el botón de añadir nuevos topics en la vista temas se disponga a la izquierda o derecha. Dicha selección se persistente mediante el uso de **UserDefault**. Además los elementos visuales de la vista Ajustes están íntegramente implementados por código, **nada de xib ni storyboards**.
- Tanto en la bista Temas como en Ajustes se han implementado mediante código diversos **constraints**.
