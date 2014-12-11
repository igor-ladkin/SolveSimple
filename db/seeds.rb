Question.destroy_all

Question.create!([{
	title: 'The most complicated question of all time.',
	body: 'How is it possible to be so stupid?'
},
{
	title: 'One of top ten unsolved problems in physics.',
	body: 'What physics explains the enormous disparity between the gravitational scale and ' +
				'the typical mass scale of the elementary particles? In other words, why is gravity ' +
				'so much weaker than the other forces, like electromagnetism?'
},
{
	title: 'Give me a cooking advice.',
	body: 'Recently, I have started reading Rspec cooking book, but I do not understand ' +
				'anything at all. How are you suppose to use these recepies? Do you bake them?'
}])

puts "Created #{Question.count} questions"
