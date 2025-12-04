# examples/workout_test.jl

# On inclut le fichier principal (chemin relatif depuis le dossier examples/)
# Si vous lancez julia depuis la racine du projet, adaptez le chemin.
# Ici, on suppose que le fichier est dans le dossier examples.
include("../src/Samo.jl") 

# On utilise le module principal
using .Samo

println("=== Démarrage du Test SamoGym ===")

# 1. Création de la session vide
# Notez le typage : Vector{AbstractActivity} permet d'accueillir n'importe quoi !
session = WorkoutSession("Jeudi 14 Mars", AbstractActivity[])

# 2. Création des exercices (Instanciation)

# Cas A : Musculation avec un entier (Int) pour le poids et un RPE
squat = StrengthExercise("Squat", 100, 5, 5, 8) 

# Cas B : Musculation avec un flottant (Float64) et PAS de RPE (nothing)
# Grâce au paramètre {T <: Real}, 82.5 est accepté sans changer la structure.
bench = StrengthExercise("Bench Press", 82.5, 8, 3, nothing)

# Cas C : Cardio
tapis = CardioExercise("Tapis de course", 20, 3.5)

# 3. Remplissage du vecteur (Polymorphisme)
push!(session.activities, squat)
push!(session.activities, bench)
push!(session.activities, tapis)

println(" Session créée avec succès avec 3 activités.")
println("   (Le vecteur contient un mélange de Strength et Cardio !)")
println()

# 4. Test de la Logique et de l'Affichage
# Cette fonction va appeler votre 'show' personnalisé et vos calculs.
summarize(session)