# examples/final_demo.jl

# On vérifie si Samo est déjà chargé pour éviter les erreurs de redéfinition
if !isdefined(Main, :Samo)
    include("../src/Samo.jl")
end
using .Samo

println("=== 💪 Démarrage de la Session SamoGym ===")

println("\n[1] Analyse de la force (Functor)")

# On instancie l'estimateur 
estimator = BrzyckiOneRepMaxEstimator()

# Disons qu'on a fait 80kg x 6 reps la semaine dernière
max_theorique = estimator(80, 6) 
max_display = round(max_theorique, digits=1)
println("Based on 80kg x 6 reps, your estimated 1RM is: $(max_display) kg")


println("\n[2] Enregistrement de la séance (Macro)")

# On crée la session avec le constructeur varargs 
session = WorkoutSession("Vendredi 15 Mars")

# On utilise la macro pour ajouter des exercices de force
@log session "Squat" 100 5 5 8 

# On peut omettre le RPE (le dernier argument est optionnel dans la macro)
@log session "Bench Press" 80 8 3 

# On ajoute du Cardio (La macro ne gère que la force pour l'instant, on l'ajoute à la main)
push!(session.activities, CardioExercise("Rameur", 20, 4.5))


println("\n[3] Résumé Automatique")
summarize(session)