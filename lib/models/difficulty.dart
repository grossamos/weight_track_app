// TODO test, if these rep numbers (5, 3 reps short) are good

enum Difficulty{
  Easy, // 5 reps short
  MediumExertion,  // three reps short
  MaximumExertion, // no reps short
  AboveMaximumExertion // one rep above
}

List<Difficulty> possibleDifficulties = [Difficulty.AboveMaximumExertion, Difficulty.MaximumExertion, Difficulty.MediumExertion, Difficulty.Easy];

int difficultyToRepsShort(Difficulty difficulty){
  switch (difficulty){
    case Difficulty.Easy:
      return 5;
    case Difficulty.MediumExertion:
      return 3;
    case Difficulty.MaximumExertion:
      return 0;
    case Difficulty.AboveMaximumExertion:
      return -1;
    default:
      throw UnimplementedError("The Difficulty you are attempting to access doesn't exist");
  }
}