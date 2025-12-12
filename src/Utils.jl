# src/Utils.jl

module Utils

using ..Types # Pour accéder aux types StrengthExercise et WorkoutSession

export AbstractOneRepMaxEstimator, BrzyckiOneRepMaxEstimator, @log

## 1. L'Estimateur de 1RM (Le Functor)

# Le type abstrait parent
abstract type AbstractOneRepMaxEstimator end

# Le Functor Brzycki (Formule : 1RM = Poids / (1.0278 - 0.0278 * Reps))
struct BrzyckiOneRepMaxEstimator <: AbstractOneRepMaxEstimator
    # Aucune donnée interne n'est nécessaire pour cette formule
end

# Rendre le struct "callable" (functor)
"""
    (calc::BrzyckiOneRepMaxEstimator)(weight::Real, reps::Int)

Estime la Force Maximale (1RM) théorique en utilisant la formule de Brzycki.
"""
function (calc::BrzyckiOneRepMaxEstimator)(weight::Real, reps::Int)
    # Si les répétitions sont 1, le 1RM est le poids lui-même.
    if reps == 1
        return Float64(weight)
    end
    # Si les répétitions sont trop élevées, la formule peut devenir moins précise,
    # mais nous l'appliquons ici pour l'exemple.
    if reps == 0
        return 0.0
    end

    # La formule de Brzycki
    return weight / (1.0278 - 0.0278 * reps)
end

## 2. La Macro @log (Syntax Sugar)

"""
    @log session name weight reps sets [rpe]

Macro de "syntax sugar" pour créer un StrengthExercise et l'ajouter
instantanément à une WorkoutSession existante.

Exemple : @log ma_session "Squat" 100 5 5 8
"""
macro log(session, name, weight, reps, sets, rpe=nothing)
    # L'utilisation de quote ... end et de esc() est essentielle
    # pour que le code soit évalué correctement dans le contexte d'appel.
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

end 