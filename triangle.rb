# Triangle Project Code.

# Triangle analyzes the lengths of the sides of a triangle
# (represented by a, b and c) and returns the type of triangle.
#
# It returns:
#   :equilateral  if all sides are equal
#   :isosceles    if exactly 2 sides are equal
#   :scalene      if no sides are equal
#
# The tests for this method can be found in
#   about_triangle_project.rb
# and
#   about_triangle_project_2.rb
#
def triangle(a, b, c)
	# WRITE THIS CODE
	
	hyp, s1, s2 = if c > a || c > b
						[c,a,b]
					elsif b > a || b > c
						[b,a,c]
					else
						[a,b,c]
					end
	
	if a <= 0 || b <= 0 || c <= 0
		raise TriangleError
	elsif s1 + s2 <= hyp
		raise TriangleError
	end
	
	type = if hyp == s1 && hyp == s2
				:equilateral
			elsif hyp == s1 || hyp == s2
				:isosceles
			else
				:scalene
			end
				
end

# Error class used in part 2.  No need to change this code.
class TriangleError < StandardError
end
