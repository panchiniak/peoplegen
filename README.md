peoplegen
=========

Fábrica de brazuca

People Generator Santa Catarina
===============================

PeopleGenSc creates fake people data for testing the Drupal module
custom_migration at Taller-Fiesc project Vacinação SESI.

Install:
cpan Business::BR::CPF;
cpan Data::RandomPerson::Names::SpanishMale;
cpan Data::RandomPerson::Names::SpanishFemale;
cpan String::Random;
cpan Badger::Timestamp;

Use:
perl -f peoplegen_sc.pl <number of generated pairs> <source file for cities>

If you wish output on a file (output.txt) type:

nohup perl -f peoplegen_sc.pl <number of generated pairs> <source file for cities> > output.txt
