# freeCodeCamp Relational Databases Certification

**[View my certificate on freeCodeCamp](https://www.freecodecamp.org/certification/ilyas-elghoulti/relational-databases-v9)**

These five projects show how I used PostgreSQL to organize related data, SQL to answer questions about it, and Bash to build programs that read and update records from the terminal.

## Certification projects

### Celestial Bodies Database

I built a PostgreSQL database called `universe` to model galaxies, stars, planets, and moons. Foreign keys connect each moon to its planet, each planet to its star, and each star to its galaxy, so a query can trace a moon all the way back to its galaxy.

### World Cup Database

I wrote a Bash script to import match results from a CSV file into tables for teams and games. With the data in PostgreSQL, I could use SQL to answer questions such as how many goals the winning teams scored and which teams played in a particular round.

### Salon Appointment Scheduler

I built a terminal program that lets a customer choose a salon service and enter an appointment time. The Bash script looks up the customer by phone number, asks for a name on the first visit, and saves the appointment with the selected service.

### Periodic Table Database

I cleaned up a PostgreSQL database of chemical elements and wrote a Bash script to search it by atomic number, symbol, or name. Looking up `1`, `H`, or `Hydrogen` retrieves the same element and displays properties such as its atomic mass and melting point.

### Number Guessing Game

I built a Bash game that picks a secret number and tells the player whether to guess higher or lower. PostgreSQL stores the results, so returning players can see how many games they have played and the fewest guesses they have needed to win.
