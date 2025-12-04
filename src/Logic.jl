# src/Logic.jl
module Logic

using ..Types

export calculate_load, summarize

function calculate_load(e::AbstractActivity)
    error("Oups! Vous n'avez pas défini comment calculer la charge pour ce type d'activité.")
end

# Méthode 1 : Pour la Musculation
# Formule : Poids * Reps * Sets
function calculate_load(e::StrengthExercise)
    return e.weight * e.reps * e.sets
end

# Méthode 2 : Pour le Cardio
# Formule arbitraire pour l'exemple : (Durée * 10) + (Distance * 2)
function calculate_load(e::CardioExercise)
    # On donne un poids arbitraire à la durée et la distance pour avoir un score
    return (e.duration * 5) + (e.distance * 10)
end

# --- 2. L'Analyse de Session (Itération) ---

function summarize(s::WorkoutSession)
    total_load = 0.0
    println("Résumé de la séance du $(s.date):")
    println("-----------------------------------")

    for ex in s.activities
        load = calculate_load(ex)
        total_load += load
        
        println(" - $ex | Charge: $load") 
    end
    
    println("-----------------------------------")
    println("Volume Total: $total_load")
end

# --- 3. Pretty Printing (Surcharge de Base.show) ---

import Base: show

function show(io::IO, e::StrengthExercise)
    rpe_str = isnothing(e.rpe) ? "" : "@ RPE $(e.rpe)"
    print(io, "🏋️ $(e.name): $(e.weight)kg x $(e.sets) x $(e.reps) $rpe_str")
end


function show(io::IO, e::CardioExercise)
    print(io, "🏃 $(e.name): $(e.duration) min / $(e.distance) km")
end

end