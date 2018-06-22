unit UnitAffichage;

interface

uses UnitRecord, GestionEcran, Windows;

var
  messageGlobal: string=''; // la variable qui contient les message d'erreur à afficher
  messageCombat: string=''; // la variable qui contient le message de combat

function repetChar(c: char; count: integer): string;
// repete 'count' fois le caractere 'c'
procedure afficheAccueil;
// affiche le menu principal
procedure afficheVille(g: Game; v: Ville);
// affiche l'écran de gestion de la ville
procedure afficheMilitaire(g: Game; c: Civilisation);
// affiche l'écran de gestion militaire
procedure afficheCombat(g: Game; c: Civilisation; niveau: integer; soldatE, canonE: integer);
// affiche l'écran de combat
procedure afficheCivilisation(g: Game; c: Civilisation);
// affiche l'écran de gestion de la civilisation
procedure affichePopup(g: Game; titre, str: string);
// affiche un popup 'str' qui se passe en appuyant sur entrée

implementation

uses UnitVille;

function repetChar(c: char; count: integer): string;
// repete 'count' fois le caractere 'c'
var
  i: integer; // compteur allant de 1 a 'count'
  str: string; // la chaine de sortie
begin
  str := '';
  for i := 1 to count do
  begin
    str := str + c;
  end;
  result := str;
end;

procedure afficheEntete(g: Game; str: String);
// affiche l'entête en haut de la fenêtre avec str au milieu
begin
  dessinerCadreXY(0, 0, 119, 4, simple, 15, 0);

  deplacerCurseurXY(2, 2);
  write('Civilisation : ');
  write(g.Civilisation.nom);

  deplacerCurseurXY(round((119 - length(str)) / 2), 2);
  write(str);

  deplacerCurseurXY(108, 2);
  write('Tour : ', g.tour);
end;

procedure afficheSaisie();
// affiche le rectangle en bas a droite et place le curseur au milieu
begin
  dessinerCadreXY(108, 36, 116, 38, double, 15, 0);
  deplacerCurseurXY(112, 37);
end;

procedure afficheMessage;
// affiche le texte d'erreur éventuel à gauche du rectangle de saisie
begin
  deplacerCurseurXY(106 - length(messageGlobal), 37);
  write(messageGlobal);
  messageGlobal := '';
end;

procedure afficheTitre(str: String);
// affiche le titre str au centre de la fenêtre
begin
  deplacerCurseurXY(60 - round(length(str) / 2), 6);
  write(str);
  deplacerCurseurXY(60 - round(length(str) / 2), 7);
  write(repetChar('-', length(str)));
end;

procedure affichePopup(g: Game; titre, str: string);
// affiche un popup 'str' qui se passe en appuyant sur entrée
begin
  effacerEcran;
  afficheEntete(g, '');
  afficheTitre(titre);

  deplacerCurseurXY(60 - round(length(str) / 2), 19);
  write(repetChar('-', length(str)));
  deplacerCurseurXY(60 - round(length(str) / 2), 20);
  write(str);
  deplacerCurseurXY(60 - round(length(str) / 2), 21);
  write(repetChar('-', length(str)));

  afficheMessage;

  afficheSaisie;
  readln;
end;

procedure afficheDetailVille(v: Ville; decal: integer);
// affiche les infos d'une ville
begin
  deplacerCurseurXY(4, decal);
  write('Nom : ', v.nom); // nom
  deplacerCurseurXY(4, decal + 1);
  write('Population : ', v.population); // population

  deplacerCurseurXY(28, decal);
  write('Nourriture : ', v.nourriture, ' / ', nourriturePourCroissance(v)); // nourriture et nourriture pour croissance
  deplacerCurseurXY(28, decal + 1);
  write('Nourriture par tour : ', nourritureParTour(v)); // nourriture par croissance

  deplacerCurseurXY(28, decal + 2);
  write('Nb tour avant croissance : ');
  if tourPourCroissance(v) <> -1 then
    write(tourPourCroissance(v)) // tour pour croissance
  else
    write('*');

  deplacerCurseurXY(70, decal);
  write('Travail par tour : ', travailParTour(v)); // travail par tour

  deplacerCurseurXY(70, decal + 1);
  if v.construction <> -1 then
  begin
    write('Construction : ', nomBatiment(v.construction)); // nom de la construction en cours
    deplacerCurseurXY(70, decal + 2);
    write('Avancement : ', v.avancementConstruction, '/', travailRequis(v)); // avancement de la construction
  end
  else
    write('Pas de construction');
end;

procedure afficheBatiments(v: Ville);
// affiche la liste des bâtiments construit
var
  decalage: integer; // entier donnant le décalage des lignes, évolue suivant le nombre de bâtiment à afficher
begin
  decalage := 0;

  // affichage ferme
  deplacerCurseurXY(4, 14);
  if (v.ferme > 0) or (v.construction = 1) then
  begin
    write('- ', nomBatiment(1), ' (niv ', v.ferme, ')');
    if (v.construction = 1) then
    begin
      write(' (construction ', v.avancementConstruction, '/', travailRequis(v), ')');
    end;
    decalage := decalage + 1;
  end;

  // affichage mine
  deplacerCurseurXY(4, 14 + decalage);
  if (v.mine > 0) or (v.construction = 2) then
  begin
    write('- ', nomBatiment(2), ' (niv ', v.mine, ')');
    if (v.construction = 2) then
    begin
      write(' (construction ', v.avancementConstruction, '/', travailRequis(v), ')');
    end;
    decalage := decalage + 1;
  end;

  // affichage carrière
  deplacerCurseurXY(4, 14 + decalage);
  if (v.carriere > 0) or (v.construction = 3) then
  begin
    write('- ', nomBatiment(3), ' (niv ', v.carriere, ')');
    if (v.construction = 3) then
    begin
      write(' (construction ', v.avancementConstruction, '/', travailRequis(v), ')');
    end;
    decalage := decalage + 1;
  end;

  // affichage caserne
  deplacerCurseurXY(4, 14 + decalage);
  if (v.caserne > 0) or (v.construction = 4) then
  begin
    write('- ', nomBatiment(4), ' (niv ', v.caserne, ')');
    if (v.construction = 4) then
    begin
      write(' (construction ', v.avancementConstruction, '/', travailRequis(v), ')');
    end;
    decalage := decalage + 1;
  end;

end;

procedure afficheVille(g: Game; v: Ville);
// affiche l'écran de gestion de la ville
var
  decalage, i: integer;
  // entier donnant le décalage des ligne, évolue suivant le nombre de bâtiment à afficher
begin
  effacerEcran;
  afficheEntete(g, '');
  dessinerCadreXY(0, 4, 119, 39, simple, 15, 0);

  afficheTitre('Vue détaillée de : ' + v.nom);

  afficheDetailVille(v, 9);

  deplacerCurseurXY(2, 13);
  write('Batiment construits :');

  afficheBatiments(v);

  decalage := nbBatiment(v);

  i := 1;
  // affichage des bâtiments possibles
  while nomBatiment(i) <> '' do
  begin
    deplacerCurseurXY(2, 16 + decalage);
    write(i, ' - ', nomBatiment(i));
    decalage := decalage + 1;
    i := i + 1;
  end;

  // affichage des choix
  deplacerCurseurXY(2, 19 + decalage);
  write('1..4 - Construire/Améliorer batiment');

  deplacerCurseurXY(2, 21 + decalage);
  write('0 - Retour au menu');

  afficheMessage;

  afficheSaisie;
end;

procedure afficheMilitaire(g: Game; c: Civilisation);
// affiche l'écran de gestion militaire
begin
  effacerEcran;
  afficheEntete(g, '');

  dessinerCadreXY(0, 4, 119, 39, simple, 15, 0);

  afficheTitre('Ecran de gestion militaire');

  deplacerCurseurXY(2, 10);
  write('Liste des troupes disponibles :');
  deplacerCurseurXY(2, 11);
  write('-------------------------------');

  deplacerCurseurXY(4, 12);
  write('1 - Soldats   : ', c.soldat);
  deplacerCurseurXY(4, 13);
  write('2 - Canons    : ', c.canon);

  deplacerCurseurXY(2, 15);
  write('Point de recrutements : ', c.recrutement);

  deplacerCurseurXY(2, 17);
  write('1..2 - Recruter une unité ');

  deplacerCurseurXY(2, 19);
  write('Lancer une attaque :');
  deplacerCurseurXY(2, 20);
  write('--------------------');
  deplacerCurseurXY(2, 22);
  write('3 - Petit camps barbare');
  deplacerCurseurXY(2, 23);
  write('4 - Grand camps barbare');

  deplacerCurseurXY(2, 25);
  write('0 - Retour au menu principal');

  afficheMessage;

  afficheSaisie;
end;

procedure afficheMessageCombat(var g:Game);
// affiche le détails de chaque tour de combat
var
  ligne1, ligne2, ligne3, ligne4: string;
  // chaine contenant la ligne 1, 2, 3 et 4 du détail du combat à afficher
begin
  // découpage du message en 4 lignes
  ligne1 := Copy(messageCombat, 1, Pos('et',messageCombat) - 1);
  Delete(messageCombat, 1, length(ligne1));
  ligne2 := Copy(messageCombat, 1, Pos('.', messageCombat));
  Delete(messageCombat, 1, length(ligne2));
  ligne3 := Copy(messageCombat, 1, Pos('et', messageCombat) - 1);
  Delete(messageCombat, 1, length(ligne3));
  ligne4 := Copy(messageCombat, 1, Pos('.', messageCombat));
  // affichage des 4 lignes
  deplacerCurseurXY(60, 9);
  write(ligne1);
  deplacerCurseurXY(60, 10);
  write(ligne2);
  deplacerCurseurXY(60, 11);
  write(ligne3);
  deplacerCurseurXY(60, 12);
  write(ligne4);
  messageCombat := '';
end;

procedure afficheCombat(g: Game; c: Civilisation; niveau: integer; soldatE, canonE: integer);
// affiche l'écran de combat
begin
  effacerEcran;
  afficheEntete(g, '');

  dessinerCadreXY(0, 4, 119, 39, simple, 15, 0);

  case niveau of
    1:
      afficheTitre('Combat contre : Petit camps barbare');
    2:
      afficheTitre('Combat contre : Grand camps barbare');
  end;

  // affichage la listes des troupes disponibles
  deplacerCurseurXY(2, 9);
  write('Descriptif de vos forces :');
  deplacerCurseurXY(2, 10);
  write('-------------------------------------');

  deplacerCurseurXY(4, 11);
  write('Soldats   : ', c.soldat);
  deplacerCurseurXY(4, 12);
  write('Canons    : ', c.canon);

  // affichage la listes des troupes ennemies
  deplacerCurseurXY(2, 15);
  write('Descriptif des forces ennemies :');
  deplacerCurseurXY(2, 16);
  write('-------------------------------------');
  couleurTexte(4);
  deplacerCurseurXY(4, 17);
  write('Soldats   : ', soldatE);
  deplacerCurseurXY(4, 18);
  write('Canons    : ', canonE);
  couleurTexte(15);

  // liste des choix
  deplacerCurseurXY(4, 20);
  write('1 - Attaquer les soldats ennemis');
  deplacerCurseurXY(4, 21);
  write('2 - Attaquer les canons ennemis');

  afficheMessageCombat(g);
  afficheMessage;

  afficheSaisie;

end;

procedure afficheCivilisation(g: Game; c: Civilisation);
// affiche l'écran de gestion de la civilisation
begin
  effacerEcran;
  afficheEntete(g, '');

  dessinerCadreXY(0, 4, 119, 39, simple, 15, 0);

  afficheTitre('Ecran de gestion de la civilisation');

  // affichage de la liste des villes
  deplacerCurseurXY(2, 9);
  write('Liste des villes de la civilisation :');
  deplacerCurseurXY(2, 10);
  write('-------------------------------------');

  dessinerCadreXY(2, 12, 117, 16, simple, 15, 0);
  afficheDetailVille(c.Ville, 13);

  // affichage des choix
  deplacerCurseurXY(4, 18);
  write('1 - Accéder à : ', c.Ville.nom);
  deplacerCurseurXY(4, 19);
  write('2 - Gestion militaire et diplomatique');

  deplacerCurseurXY(4, 21);
  write('9 - Fin du tour');
  deplacerCurseurXY(4, 22);
  write('0 - Quitter la partie');

  afficheMessage;

  afficheSaisie;
end;

procedure afficheAccueil;
// affiche l'écran d'accueil
begin
  effacerEcran;
  writeln('');
  writeln('');
  writeln('');
  writeln('                     ══════════════════════════════════════════════════════════════════════════════');
  writeln('');
  writeln('              ██████╗██╗██╗   ██╗██╗██╗     ██╗███████╗ █████╗ ████████╗██╗ ██████╗ ███╗   ██╗     ██████╗ ');
  writeln('             ██╔════╝██║██║   ██║██║██║     ██║╚══███╔╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║    ██╔═████╗');
  writeln('             ██║     ██║██║   ██║██║██║     ██║  ███╔╝ ███████║   ██║   ██║██║   ██║██╔██╗ ██║    ██║██╔██║');
  writeln('             ██║     ██║╚██╗ ██╔╝██║██║     ██║ ███╔╝  ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║    ████╔╝██║');
  writeln('             ╚██████╗██║ ╚████╔╝ ██║███████╗██║███████╗██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║    ╚██████╔╝');
  writeln('              ╚═════╝╚═╝  ╚═══╝  ╚═╝╚══════╝╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝     ╚═════╝ ');
  writeln('');
  writeln('                     ══════════════════════════════════════════════════════════════════════════════');
  writeln('');
  writeln('Bienvenu dans CIVILIZATION 0 - Call to Coding');
  writeln('');
  write('Batissez un empire qui laissera sa marque dans l''histoire, depuis ses premiers pas à l''époque de l''Antiquité jusqu''en l''');
  write('an 3000. Lancez-vous dans une conquête au cours de laquelle chaque stratégie que vous concevez, chaque découverte techno');
  write('logique que vous faites et chaque guerre que vous déclarez a des répercussions sur l''avenir de votre empire. Répondez à ');
  writeln('l''appel du pouvoir. L''avenir est entre vos mains.');
  writeln('');
  writeln('     1 - Débuter une nouvelle partie');
  writeln('');
  writeln('     2 - Quitter le jeu');
end;

end.
