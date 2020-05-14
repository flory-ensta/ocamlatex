# OcamLaTEX exemple de presentation

_author:Pierre-Elisee FLORY

__date:Jeudi 14 mai 2020

___

## Introduction

Ce document a pour but de montrer les capacites du programme OCamLaTEX qui permet de produir des documents LaTEX a partir de fichiers Markdown, un langage de balisage leger qui permet de creer un fichier structure rapidement.

Il est donc presente dans ce document l'ensemble des fonctionnalites prises en compte par OCamLatex.

En Markdown, les elements sont séparés par un saut de ligne (2 si on veut effectivement produire un saut de ligne dans le fichier LaTEX). Le non respect de cette regle peut produire un fichier source LaTEX comportant des erreurs mais comilant correctement.

## Fonctionnalites

### Texte

#### Formattage des mots

OCamLaTEX prend en compte les zones de textes **accentuees en gras** ou bien *en italique*.

#### Citation

Le texte suivant est une citation:

> Ceci est une citation

#### Code

`On peut integrer une ligne de code comme ceci`

```
Ou bien on peut definir un bloc de code
Et ecrire du code sur plusieurs lignes
$ echo "Hello World !
```

Et meme utiliser de la coloration syntaxique propre au langage:

```c
#include <stdio.h>

void checkPrimeNumber();

int main()
{
    checkPrimeNumber();    // argument is not passed
    return 0;
}

// return type is void meaning doesn't return any value
void checkPrimeNumber()
{
    int n, i, flag = 0;

    printf("Enter a positive integer: ");
    scanf("%d",&n);

    for(i=2; i <= n/2; ++i)
    {
        if(n%i == 0)
        {
            flag = 1;
        }
    }
    if (flag == 1)
        printf("%d is not a prime number.", n);
    else
        printf("%d is a prime number.", n);
}
```

#### Listes

On peut creer tres rapidement une lsite ainsi:

* a
* b
* c
* d

### Integration extra textuel

#### Liens

On peut ajouter un [lien hypertexte](https://www.youtube.com/watch?v=dQw4w9WgXcQ) comme ca!

#### Images

On peut egalement integrer une image au document comme ca: ![Ensta logo](logo.jpg)

### Extra

#### Ligne separatrice horizontale

Du texte...


---

Cette ligne est separee de la precedente par une ligne horizontale !

## Conclusion

Ceci est un document de presentation du fonctionnement d'OCamLaTEX. Si vous voulez le mettre en pratique, vous pouvez le faire facilement:

```bash
$ cd src/
$ make
$ ocamlrun ocamlatex source_file.md > output_file.tex
```