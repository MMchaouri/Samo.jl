# examples/workout_test.jl

# On inclut le fichier principal (chemin relatif depuis le dossier examples/)
include("../src/Samo.jl") 

# On utilise le module principal
using .Samo

println("=== Démarrage du Test SamoGym ===")

# 1. Création de la session vide
session = WorkoutSession("Jeudi 14 Mars", AbstractActivity[])

# 2. Création des exercices (Instanciation)

# Cas A : Musculation avec un entier (Int) pour le poids et un RPE
squat = StrengthExercise("Squat", 100, 5, 5, 8) 

# Cas B : Musculation avec un flottant (Float64) et PAS de RPE (nothing)
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


brzycki = BrzyckiOneRepMaxEstimator()
# Estime le 1RM de l'Overhead Press (50kg x 5 reps)
max_press = brzycki(50.0, 5)

println("1RM estimé pour l'Overhead Press: $max_press kg")

# 4. Test de la Logique et de l'Affichage
summarize(session)