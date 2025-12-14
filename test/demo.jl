using Samo
using Unitful
using UnicodePlots

# ==============================================================================
# 1. SETUP (Types Paramétriques & Constructeurs)
# ==============================================================================
# Concept : Parametric Types {T <: Number}
# "Regardez : 'deadlift' utilise des kg (Quantity), mais le struct accepterait aussi des Int !"
deadlift = StrengthExercise("Deadlift", 140u"kg", 5, 3) 
bench    = StrengthExercise("Bench Press", 225u"lb", 5, 5) 
bench1   = StrengthExercise("Bench Press", 100, 5, 5) # will be 100kg

# ==============================================================================
# 2. SLURPING & POLYMORPHISME (Abstract Types)
# ==============================================================================
# Slurping car on passe les arguments naturellement sans crochets
# Concept 2 : Polymorphisme
# "Notre session contient à la fois de la Force (bench) et du Cardio (run) !"
run_ex = CardioExercise("Warmup Run", 15u"minute", 3.0u"km")
today  = WorkoutSession("2025-12-14", deadlift, bench, run_ex)

println("--- Session Créée (Polymorphisme) ---")
println(today)

# ==============================================================================
# 3. LOGIQUE (multiple dispatching)
# ==============================================================================
# Concept 1 : Dispatch Multiple
# "calculate_load() change de comportement automatiquement selon le type (Force vs Cardio)."
summarize(today)

# ==============================================================================
# 4. LA MACRO (Métaprogrammation)
# ==============================================================================
# Concept : Métaprogrammation
# "La macro @log écrit le code 'push!' à notre place pour aller plus vite."
@log today "Speed Squat" 100u"kg" 3 10 7

# ==============================================================================
# 5. LE FONCTEUR (Objets Appelables)
# ==============================================================================
# Concept : Foncteurs (Callable Structs)
# "Le struct 'estimator' s'utilise comme une fonction f(x, y)."
estimator = BrzyckiOneRepMaxEstimator()
println("\n--- Estimation 1RM (Foncteur) ---")
println("Max théorique au Bench : $(estimator(225, 5)) lbs")

# ==============================================================================
# 6. PERSISTANCE (État Global)
# ==============================================================================
# "On sauvegarde tout dans notre vecteur global HISTORY."
save_session(today)
save_session(WorkoutSession("Hier_Matin", CardioExercise("Run", 30u"minute", 5.0u"km")))
save_session(WorkoutSession("Hier_Soir", CardioExercise("Row", 15u"minute", 2.0u"km"), bench1))

# ==============================================================================
# 7. ANALYSE (Views & Gestion Mémoire)
# ==============================================================================
# Concept : Views
# "On utilise @view pour créer une fenêtre sur l'historique SANS copier les données (Zéro allocation)."
latest = analyze_progress(2)
println(latest)

# ==============================================================================
# 8. VISUEL (UnicodePlots)
# ==============================================================================
# "Visualisation du volume directement dans le terminal."
println("\n--- Graphique de Progression ---")
plot_progress()