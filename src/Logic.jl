module Logic

using ..Types
using Unitful # pour les conversions

export calculate_load, summarize

function calculate_load(e::AbstractActivity)
    error("Pas défini")
end

# Méthode Muscu : Conversion automatique en KG
function calculate_load(e::StrengthExercise)
    # si unite existe -> on le convertit en kg
    if isa(e.weight, Unitful.Quantity)
        weight_kg = uconvert(u"kg", e.weight)
        val = ustrip(weight_kg)
    else
        # sinon c'est kg par defaut
        val = e.weight
    end
    
    return val * e.reps * e.sets
end

# Méthode Cardio
function calculate_load(e::CardioExercise)
    # On convertit tout en min et km pour normaliser le score
    t_min = ustrip(uconvert(u"minute", e.duration))
    d_km  = ustrip(uconvert(u"km", e.distance))
    
    return (t_min * 5) + (d_km * 10)
end

# Surcharge de l'affichage
import Base: show

function show(io::IO, e::StrengthExercise)
    rpe_str = isnothing(e.rpe) ? "" : "@ RPE $(e.rpe)"
    print(io, "🏋️ $(e.name): $(e.weight) x $(e.sets) x $(e.reps) $rpe_str")
end

function show(io::IO, e::CardioExercise)
    print(io, "🏃 $(e.name): $(e.duration) / $(e.distance)")
end

function summarize(s::WorkoutSession)
    total_load = 0.0
    println("Résumé Physique de la séance du $(s.date):")
    println("-----------------------------------")
    for ex in s.activities
        load = calculate_load(ex)
        total_load += load
        # On arrondit le load 
        println(" - $ex | Charge (Normalisée Kg): $(round(load, digits=1))") 
    end
    println("-----------------------------------")
    println("Volume Total (Unitless Score): $(round(total_load, digits=1))")
end

end