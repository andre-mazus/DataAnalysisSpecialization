//DROP DATABASE
db.dropDatabase();

// CREATE DB or DROP DB
use sprint5;


// CREATED A PYTHON FILE TO INSERT A COMMA AT THE END OF EACH LINE

//IMPORTED THE DATA (imported in the macOS terminal)

mongoimport --db sprint5 --collection users --file /Users/andre/Documents/1data_analist/CURSO_IT_ACADEMY/sprint5/user1.json --jsonArray

mongoimport --db sprint5 --collection comments --file /Users/andre/Documents/1data_analist/CURSO_IT_ACADEMY/sprint5/comments1.json --jsonArray

mongoimport --db sprint5 --collection movies --file /Users/andre/Documents/1data_analist/CURSO_IT_ACADEMY/sprint5/movies1.json --jsonArray

mongoimport --db sprint5 --collection sessions --file /Users/andre/Documents/1data_analist/CURSO_IT_ACADEMY/sprint5/sessions.json --jsonArray

mongoimport --db sprint5 --collection theaters --file /Users/andre/Documents/1data_analist/CURSO_IT_ACADEMY/sprint5/theaters1.json --jsonArray

// LEVEL 1 EXERCISE 1

db.comments.find().sort({ date: 1 }).limit(2).pretty();
db.users.countDocuments(); // 185 users
db.theaters.countDocuments({"location.address.state" : "CA"}); //169
db.users.find().sort({ _id: 1 }).limit(1); // Ned Stark
db.movies.countDocuments({"genres" : "Comedy"}) // 7024

// LEVEL 1 EXERCISE 2
db.movies.find({year : 1932, $or: [
                    { genres: "Drama" },
                    { languages: "French" }]})

// LEVEL 1 EXERCISE 3 
db.movies.find({"countries" : "USA", 
                "awards.wins" : { $gt: 5, $lt: 9 }, 
                year : { $gt: 2012, $lt: 2014 }})

//LEVEL 2 EXERCISE 1

db.comments.countDocuments({"email" : /@gameofthron\.es$/}) // 22841

// LEVEL 2 EXERCISE 2

db.theaters.aggregate([
  { $match: { "location.address.state": "DC" } },
  {
    $group: {
      _id: "$location.address.zipcode",
      count: { $sum: 1 }
    }
  },
  { $sort: { _id: 1 } }
])


// LEVEL 3 EXERCISE 1

db.movies.find({"directors" : "John Landis", "imdb.rating": {$gt: 7.5, $lt: 8,}})

// LEVEL 3 EXERCISE 2