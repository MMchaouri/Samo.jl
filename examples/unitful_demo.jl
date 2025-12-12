# examples/unitful_demo.jl

using Pkg
Pkg.activate(".") # S'assure qu'on utilise l'env local

using Unitful 

if !isdefined(Main, :Samo)
    include("../src/Samo.jl")
end
using .Samo

println("=== ⚛️ SamoGym: Mode Physique Activé ===")

session = WorkoutSession("Samedi International")

# 1. Ajout d'un exo en KILOS (Standard européen)
# on note le u"kg" collé au nombre
@log session "Squat" 100u"kg" 5 5 8

# 2. Ajout d'un exo en LIVRES (Standard américain)
# 225 lbs équivaut environ à 102 kg.
# La macro n'a pas besoin de changer, elle passe l'expression telle quelle !
@log session "Deadlift (US)" 225u"lb" 5 3 9

# 3. Ajout Cardio avec des unités de temps et de distance
# 30 minutes, 5 kilomètres
push!(session.activities, CardioExercise("Run", 30u"minute", 5000u"m"))

# 4. Résumé
# Le Deadlift (lbs) sera converti en kg pour le calcul de charge !
summarize(session)

println("\n--- Preuve de conversion ---")
println("225 lbs est égal à : ", uconvert(u"kg", 225u"lb"))