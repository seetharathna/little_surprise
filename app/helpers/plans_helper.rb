module PlansHelper

def display_plan(plan,name,points,credit)
unless plan.points.blank? ||plan.credit.blank? || plan.name.blank?
 return plan.name + ' ' + plan.points + ' ' + 'Points' + ' ' + '$' + plan.credit
end
end

end



