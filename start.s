# ===== Section donnees =====
.data 
    grille:     .space 100 #Grille de char de 10x10 soit 100 octet
    strNbCoup:	.asciiz "Le nombre de tir est de "
    
# ===== Section code =====  
.text

# ----- Main ----- 
main:
    jal initPartie
    jal displayGrille
    jal simulationJeu
    #j'ai retire jal displayGrille car la traque affiche deja la grille finale en affichant la grille à chaque tir
    j   exit 

# ----- Fonctions -----

# ----- Fonction initPartie -----
# Objectif : Génère une nouvelle partie à chaque appel
# Registres utilises : $a0, $a1

initPartie:
    add     $sp, $sp, -4        # Sauvegarde de la reference du dernier jump
    sw      $ra, 0($sp)
    jal initGrille
    li  $a0, 5
    li  $a1, 65 # 'A' pour Aircraft Carrier (Porte-Avion)
    jal setShip
    li  $a0, 4  
    li  $a1, 66 # 'B' pour Battleship (Cuirassé)
    jal setShip
    li  $a0, 3
    li  $a1, 67 # 'C' pour Cruiser (Croiseur)
    jal setShip
    li  $a0, 3
    li  $a1, 83 # 'S' pour Submarine (Sous-marin)
    jal setShip
    li  $a0, 2
    li  $a1, 68 # 'D' pour Destroyer (Torpilleur)
    jal setShip

    lw      $ra, 0($sp)                 # On recharge la reference 
    add     $sp, $sp, 4                 # du dernier jump
    jr $ra

# ----- Fonction initGrille -----
# Objectif : Charge la grille avec '.' (Case vide)
# Registres utilises : $t[0-3]

initGrille:
    la      $t0, grille     # Chargement de l'adresse de la grille
    li      $t1, 0          # Initialisation du compteur de boucle
    li      $t3, 46         # Code ASCII du caractere '.'
    boucle_initGrille:
        bge     $t1, 100, end_initGrille # Arret lorsque toute la grille est initialisee
            add     $t2, $t0, $t1   # Calcul de l'adresse de la case courante
            sb		$t3, 0($t2)		# Placement du caractere '.' dans la case
            addi    $t1, $t1, 1     # Passage à la case suivante
        j boucle_initGrille
    end_initGrille:
        jr $ra

# ----- Fonction displayGrille -----
# Objectif : Affiche la grille avec les indicateur de coordonnées
# Registres utilises : $t[0-3], $v0, $a[0-1]

displayGrille:
    add     $sp, $sp, -4        # Sauvegarde de l'adresse de retour
    sw      $ra, 0($sp)
    jal displayLettres          # Affichage des lettres de colonnes
    la      $t0, grille         # Chargement de l'adresse de la grille
    li      $t1, 0              # Initialisation de l'indice de parcours
    
    boucle_displayGrille:
        bge     $t1, 100, end_displayGrille # Fin lorsque toutes les cases sont affichées
        
            move $a0, $t1	# Passage de l'indice courant pour le calcul du modulo
            li $a1, 10		# Diviseur pour detecter un changement de ligne
            jal getModulo	# Calcul du modulo et du quotient
            bne $v0 0 ifNotZero	# Si pas debut de ligne, on continue l'affichage
            
            jal addNewLine	# Retour à la ligne à l'écran
            move $a1, $v1	# Recuperation du numero de ligne
            jal addLineCount	# Affichage du numero de ligne
            
            ifNotZero:
            	add     $t2, $t0, $t1           # Calcul de l'adresse de la case a afficher
            	lb      $a0, ($t2)              # Chargement du caractere a afficher
            	li      $v0, 11                 # Service systeme d'affichage d'un caractere
            	syscall
	
            	addi    $t1, $t1, 1            # Passage a la case suivante
        	j boucle_displayGrille
        	
    end_displayGrille:
        jal     addNewLine
        lw      $ra, 0($sp)                 # Restauration de l'adresse de retour
        add     $sp, $sp, 4
    	jr $ra

# ----- Fonction displayLettres -----
# Objectif : afficher les lettres de A à J
# Regitres utilises : $t0, $v0, $a0

displayLettres:
 
    li $v0, 11                                # Service d'affichage d'un caractere  
    li $a0, 32                                # Affichage d'un espace pour l'alignement
    syscall
    li $v0, 11                                # Service d'affichage d'un caractere  
    li $a0, 32                                # Second espace pour l'alignement
    syscall
    li $t0, 65                                # Code ASCII de la lettre 'A'

    boucleAffichage:
   	move $a0, $t0                             # Chargement de la lettre a afficher
	li $v0, 11                                # Service d'affichage
	syscall
	addi $t0, $t0, 1                          # Passage a la lettre suivante
    	ble $t0, 74, boucleAffichage              # Boucle jusqu'a la lettre 'J'
    	jr $ra                                    # Retour a l'appelant


# ----- Fonction addNewLine -----  
# Objectif : fait un retour a la ligne a l'ecran
# Registres utilises : $v0, $a0

addNewLine:
    li      $v0, 11         # Service d'affichage d'un caractere
    li      $a0, 10         # Code ASCII du retour a la ligne
    syscall
    jr      $ra

# ----- Fonction addLineCount -----
# Objectif : affiche le numero de la ligne
# Registres utilises : $v0, $a0, $a1
# Paramètre : $a1 (Ligne en cours : res du modulo + 1)

addLineCount:
	beq $a1, 9 if10		# Cas particulier de la ligne 10
				
	move $a0, $a1		# Recuperation du numero de ligne
	addi $a0, $a0, 49	# Conversion en caractere ASCII
    	li   $v0, 11		# Service d'affichage
    	syscall
    	
    	li $v0, 11		# Affichage d'un espace apres le numero
    	li $a0, 32
    	syscall
    	
	jr $ra
	
	if10:			# Gestion de l'affichage de la ligne 10
		li $a0, 49	# Affichage du caractere '1'
		li $v0, 11
		syscall
		
		li $a0, 48	# Affichage du caractere '0'
		li $v0, 11
		syscall
		jr $ra

# ----- Fonction getModulo ----- 
# Objectif : Fait le modulo (a mod b)
#   $a0 represente le nombre a (doit etre positif)
#   $a1 represente le nombre b (doit etre positif)
# Resultat (reste) dans : $v0
# Resultat (quotient) dans : $v1
# Registres utilises : $a0 et $a1

getModulo: 
    li $v1, 0
    sub     $sp, $sp, 4
    sw      $ra, 0($sp)
    boucle_getModulo:
        blt $a0, $a1, end_getModulo
        addi $v1, $v1, 1
        sub $a0, $a0, $a1
        j boucle_getModulo
    end_getModulo:
    move    $v0, $a0
    lw      $ra, 0($sp)
    add     $sp, $sp, 4
    jr $ra

# ----- Fonction getAleatoire ----- 
# Objectif : Génère un nombre aléatoire de 0 à n-1
#   $a1 represente la valeur max-1
# Resultat dans : $a0
# Registres utilises : $a0, $a1, $v0

getAleatoire:
    li $v0, 42
    syscall
    jr $ra

# ----- Fontion setShip -----
# Objectif : place un bateau de taille donné.
#   $a0 represente la taille en nombre de case du bateau à placer
#   $a1 represente le caraètre pour représenter le bateau
# Registres utilises : $a0, $a1, $s[0-4], $t[0-4]

setShip:
    sub     $sp, $sp, 4
    sw      $ra, 0($sp)     # Sauvegarde de l'adresse de retour

    move 	$s0, $a0	# Copie de la taille du bateau dans $s0
    move    $s4, $a1        # Copie du caractere representant le bateau
    try_setShip:
        #Choix de l'axe (horizontale ou verticale)
        li      $a1, 2          # Limite pour obtenir un resultat aleatoire entre 0 et 1
        jal getAleatoire        # Generation aleatoire de l'orientation
        move 	$s1, $a0	# Sauvegarde de l'orientation choisie
        # Placement en fonction de l'axe
        beq     $s1, 1, placeVerticale  # Si 1, placement du bateau a la verticale
        j       placeHorizontale        # Sinon, placement du bateau a l'horizontale

    end_setShip:
        lw      $ra, 0($sp)     # Restauration de l'adresse de retour
        add     $sp, $sp, 4     # Liberation de la pile
    jr $ra

# ----- Fontion placeHorizontale -----
# Objectif : place aléatoirement un bateau de manière horizontale.
#   Prends les paramètres de setShip
# Registres utilises : $v0, $a0, $a1, $s[0-4], $t[0-4]

placeHorizontale:	
    	recherchePlaceHorizontale:
    		li $a1, 10			# Limite de selection de colonne
    		sub $a1, $a1, $s0		# Ajustement pour eviter le debordement
		jal getAleatoire		# Generation de la colonne aleatoire
		move $s3, $a0			# Sauvegarde de la colonne
		li $a1, 10			# Limite de selection de ligne
		jal getAleatoire		# Generation de la ligne aleatoire
		move $s2, $a0			# Sauvegarde de la ligne
		jal verifPlaceHorizontale	# Verification de la disponibilite
	
	li $t0, 0			# Initialisation du compteur
	la $t1, grille			# Adresse de base de la grille
	add $t1, $t1, $t2		# Positionnement au debut du bateau
	bouclePlacementHorizontale:
		sb $s4, 0($t1)		# Ecriture du caractere du bateau
		addi $t1, $t1, 1	# Deplacement vers la droite
		addi $t0, $t0, 1	# Incrementation du compteur
		bne $t0, $s0, bouclePlacementHorizontale
        j end_setShip

# ----- Fontion verifPlaceHorizontale -----
# Objectif : verifie si le placement (horizontale) est possible.
#   $s0 contient la taille du navire
#   $s2 contient la ligne 
#   $s3 contient la colonne
# Retourne 0 si placement ok, 1 sinon
# Registres utilises : $v0, $t[0-4], $s0, $s2, $s3

verifPlaceHorizontale:
	li $t0, 0		        # Compteur de verification
	mul $t2, $s2, 10	        # Calcul de l'indice de ligne
	add $t2, $t2, $s3	        # Ajout de la colonne
	la $t1, grille		        # Adresse de la grille
	add $t1, $t1, $t2	        # Position de depart
	
	boucleVerifPlacementHorizontale:
		lb $t4, 0($t1)		# Lecture du contenu de la case
		bne $t4, 46, falseHorizontale # Case deja occupee
		
		addi $t0, $t0, 1	# Incrementation du compteur
		addi $t1, $t1, 1	# Avancement horizontal
		bne $t0, $s0, boucleVerifPlacementHorizontale
        	
		li $v0, 0	        # Placement valide
		jr $ra
	
	falseHorizontale:       	
		li $v0, 1	        # Placement invalide
		j try_setShip

# ----- Fontion placeVerticale -----
# Objectif : place aléatoirement un bateau de manière verticale.
#   Prends les paramètres de setShip
# Registres utilises : $v0, $a0, $a1, $s[0-4], $t[0-4]

placeVerticale: 	
    	recherchePlaceVerticale:
    		li $a1, 99
    		mul $t0, $s0, 10		# Calcul de l'espace vertical occupe
    		sub $a1, $a1, $t0		# Ajustement des limites
		jal getAleatoire		# Generation de la position aleatoire
		jal verifPlaceVerticale		# Verification de la disponibilite
	
	li $t0, 0	 	        # Initialisation du compteur
	la $t1, grille		        # Adresse de la grille
	add $a0, $a0, $t1	        # Position de depart
	bouclePlacementVerticale:
		sb $s4, 0($a0)		# Ecriture du caractere du bateau
		addi $a0, $a0, 10	# Deplacement vers le bas
		addi $t0, $t0, 1	# Incrementation du compteur
		bne $t0, $s0, bouclePlacementVerticale
		
        j end_setShip

# ----- Fontion verifPlaceVerticale -----
# Objectif : verifie si le placement (verticale) est possible.
#   $s0 contient la taille du navire
#   $s2 contient la ligne 
#   $s3 contient la colonne
# Retourne 0 si placement ok, 1 sinon
# Registres utilises : $v0, $t[0-4], $s0, $s2, $s3

verifPlaceVerticale:
	li $t0, 0		        # Compteur de verification
	la $t1, grille		        # Adresse de la grille
	add $t1, $t1, $a0	        # Position de depart
	
	boucleVerifPlacementVerticale:
		lb $t4, ($t1)		# Lecture du contenu de la case
		bne $t4, 46, falseVerticale # Case deja occupee
		addi $t0, $t0, 1	# Incrementation du compteur
		addi $t1, $t1, 10	# Avancement vertical
		bne $t0, $s0, boucleVerifPlacementVerticale
        	
		li $v0, 0	        # Placement valide
		jr $ra
		
	falseVerticale:       	
		li $v0, 1	        # Placement invalide
		j try_setShip

		
# ----- Fonction simulationJeu -----
# Objectif : Simule une partie avec une grille déjà généré.
# Registres utilises : $s[0-3]
		
simulationJeu:
	sub     $sp, $sp, 4
    	sw      $ra, 0($sp)     # Sauvegarde de l'adresse de retour
    
	li $s0, 0	# Initialisation du compteur total de tirs
	li $s1, 0	# Initialisation du compteur de tirs reussis
	
	whileNb_coups_but:
		li $a1, 100				# Borne maximale pour un tir aleatoire (0 a 99)
		jal getAleatoire			# Generation d'une position de tir aleatoire
		move $s3, $a0				# Sauvegarde de l'indice tire
		la $s2, grille				# Chargement de l'adresse de base de la grille
		add $s2, $s3, $s2			# Calcul de l'adresse de la case ciblee
		jal traque				# Execution du tir et de la traque eventuelle
		bne $s1, 17, whileNb_coups_but		# Boucle tant que tous les bateaux ne sont pas coules
		
	la $a0, strNbCoup	# Chargement de la chaine de texte a afficher
	li $v0, 4		# Service systeme pour afficher une chaine
	syscall
	
	move $a0, $s0		# Chargement du nombre total de tirs effectues
	li $v0, 1		# Service systeme pour afficher un entier
	syscall
	
	lw      $ra, 0($sp)	# Restauration de l'adresse de retour
        add     $sp, $sp, 4     # Liberation de la pile
        jr $ra


# ----- Fontion traque -----     
# Objectif : Vérifie la présence d'un navire et le traque de manière récursive
# Registres utilises : $t[8-9], $s[0-3]

traque:
	sub     $sp, $sp, 8
    	sw      $ra, 0($sp)     	# Sauvegarde de l'adresse de retour pour les appels recursifs
    	sw      $s3, 4($sp)		# Sauvegarde de l'indice de la case courante
    	
	lb $t8, 0($s2)			# Lecture du contenu de la case ciblee
	beq $t8, 126, finTraque		# Si la case contient '~', le tir a deja ete effectue
	beq $t8, 88, finTraque		# Si la case contient 'X', le tir a deja ete effectue
	
	addi $s0, $s0, 1		# Incremente le nombre total de tirs effectues
	
	bne $t8, 46, toucher		# Si la case n'est pas vide ('.'), alors un bateau est touche

	li $t8, 126			# Chargement du caractere '~' pour un tir rate
	sb $t8, 0($s2)			# Marquage de la case comme tir rate
	jal displayGrille		# Affichage de la grille mise a jour
	
	j finTraque			# Fin du traitement du tir
	
	toucher:
		addi $s1, $s1, 1	# Incremente le nombre de cases touchees
		li $t8, 88		# Chargement du caractere 'X' pour un tir reussi
		sb $t8, 0($s2)		# Marquage de la case comme touchee
		jal displayGrille	# Affichage de la grille mise a jour
		
		ble $s3, 9, pasDessus	# Si on est sur la premiere ligne, pas de tir vers le haut
		subi $s2, $s2, 10	# Deplacement vers la case au-dessus
		subi $s3, $s3, 10
		jal traque		# Appel recursif pour tester la case du dessus
		
		la $s2, grille		# Rechargement de l'adresse de base de la grille
		lw $s3, 4($sp)		# Restauration de l'indice d'origine
		add $s2, $s3, $s2
		
		pasDessus:
			bge  $s3, 90, pasDessous	# Si on est sur la derniere ligne, pas de tir vers le bas
			addi $s2, $s2, 10		# Deplacement vers la case en dessous
			addi $s3, $s3, 10
			jal traque			# Appel recursif pour tester la case du dessous
			
			la $s2, grille			# Rechargement de l'adresse de base de la grille
			lw $s3, 4($sp)			# Restauration de l'indice d'origine
			add $s2, $s3, $s2
			
			pasDessous:
				beq  $s3, 0, pasGauche		# Si on est sur la premiere colonne, pas de tir a gauche
				subi $s2, $s2, 1		# Deplacement vers la case de gauche
				subi $s3, $s3, 1
				jal traque			# Appel recursif pour tester la case de gauche
		
				la $s2, grille			# Rechargement de l'adresse de base de la grille
				lw $s3, 4($sp)			# Restauration de l'indice d'origine
				add $s2, $s3, $s2
				
				pasGauche:
					beq  $s3, 99, finTraque		# Si on est sur la derniere colonne, pas de tir a droite
					addi $s2, $s2, 1		# Deplacement vers la case de droite
					addi $s3, $s3, 1
					jal traque			# Appel recursif pour tester la case de droite
		
					la $s2, grille			# Rechargement de l'adresse de base de la grille
					lw $s3, 4($sp)			# Restauration de l'indice d'origine
					add $s2, $s3, $s2
					
					finTraque:
					
		lw $s3, 4($sp)		# Restauration finale de l'indice avant retour
		lw      $ra, 0($sp)	# Restauration de l'adresse de retour
        	add     $sp, $sp, 8     # Liberation de la pile
        	jr $ra

exit: 
    li $v0, 10  #Chargement appel systeme 10 (Sortie)
    syscall
