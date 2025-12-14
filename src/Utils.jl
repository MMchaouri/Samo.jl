# src/Utils.jl

module Utils

using UnicodePlots

using ..Types # Pour accéder aux types StrengthExercise et WorkoutSession

export AbstractOneRepMaxEstimator, BrzyckiOneRepMaxEstimator, @log
export analyze_progress, save_session, HISTORY
export plot_progress

## 1. L'Estimateur de 1RM (Functor)

# Le type abstrait parent
abstract type AbstractOneRepMaxEstimator end

# Le Functor Brzycki : le poids maximum pour une rep
struct BrzyckiOneRepMaxEstimator <: AbstractOneRepMaxEstimator
    # On a besoin d'acunne donne pour cette formule
end

# Rendre le struct "callable" (functor)
"""
    (calc::BrzyckiOneRepMaxEstimator)(weight::Real, reps::Int)

Estime la Force Maximale (1RM) théorique en utilisant la formule de Brzycki.
"""
function (calc::BrzyckiOneRepMaxEstimator)(weight::Real, reps::Int)
    # Si les répétitions sont 1, le 1RM est le poids lui-même (evident)
    if reps == 1
        return Float64(weight)
    end
    # Si les répétitions sont trop élevées, la formule peut devenir moins précise...
    if reps == 0
        return 0.0
    end

    # La formule de Brzycki
    return round(weight / (1.0278 - 0.0278 * reps), digits=1)
end

## 2. La Macro @log (Syntax Sugar)

"""
    @log session name weight reps sets [rpe]

Macro de "syntax sugar" pour créer un StrengthExercise et l'ajouter
instantanément à une WorkoutSession existante.

Exemple : @log ma_session "Squat" 100 5 5 8
"""
macro log(session, name, weight, reps, sets, rpe=nothing)
    return quote
        # On crée l'exercice en utilisant le constructeur que nous avons défini
        # (celui qui gère le 'nothing' par défaut si rpe est omis).
        ex = StrengthExercise(
            $(esc(name)), 
            $(esc(weight)), 
            $(esc(reps)), 
            $(esc(sets)), 
            $(esc(rpe))
        )
        # On ajoute l'exercice à la session fournie par l'utilisateur
        push!($(esc(session)).activities, ex)
    end
end



# ==============================================================================
# 3. Historique & Analyse (Via Views)
# ==============================================================================

# Notre "Fausse Database". Elle persiste tant que la session Julia est ouverte.
const HISTORY = Vector{WorkoutSession}()

"""
    save_session(s::WorkoutSession)

Sauvegarde la séance dans l'historique global "HISTORY".
"""
function save_session(s::WorkoutSession)
    push!(HISTORY, s)
    println("✅ Séance du $(s.date) sauvegardée ! Total historique : $(length(HISTORY)) séances.")
end

"""
    analyze_progress(last_n::Int)

Mode Auto : Analyse les `n` dernières séances depuis l'historique global.
"""
function analyze_progress(last_n::Int)
    # On redirige vers la fonction manuelle en utilisant le HISTORY global
    return analyze_progress(HISTORY, last_n)
end

"""
    analyze_progress(sessions::Vector{WorkoutSession}, last_n::Int)

Mode Manuel : Renvoie une VIEW (fenêtre) sur les `n` dernières séances.
Utilisation de  @view pour ne pas copier les données -> Performance et memoire optimisation
"""
function analyze_progress(sessions::Vector{WorkoutSession}, last_n::Int)
    if isempty(sessions)
        println("⚠️ L'historique est vide !")
        return nothing
    end


    start_idx = max(1, length(sessions) - last_n + 1)
    
    # La magie des Views : Zéro copie mémoire, juste une référence !
    recent_window = @view sessions[start_idx:end]
    
    println("📊 Création d'une 'View' des $(length(recent_window)) dernières séances...")
    return recent_window
end


# ==============================================================================
# 4. Graphiques (UnicodePlots)
# ==============================================================================

"""
    plot_progress()

Affiche un graphique du volume d'entraînement (nombre d'exos) depuis l'historique global.
Utilise UnicodePlots pour un rendu direct dans le terminal.
"""
function plot_progress()
    if isempty(HISTORY)
        println("❌ Aucun historique à afficher.")
        return
    end
    
    # Extraction des données : Session Index vs Nombre d'activités / Approche fonctionelle
    y_data = [length(s.activities) for s in HISTORY]
    x_data = 1:length(HISTORY)

    # graphique ASCII
    plt = lineplot(x_data, y_data, 
        title="Progression du Volume", 
        xlabel="Séance #", 
        ylabel="Nb Exercices",
        border=:ascii
    )

    show(plt)
end

end