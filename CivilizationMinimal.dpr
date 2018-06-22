program CivilizationMinimal;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Windows,
  GestionEcran in 'GestionEcran.pas',
  UnitAffichage in 'UnitAffichage.pas',
  UnitGestion in 'UnitGestion.pas',
  UnitInit in 'UnitInit.pas',
  UnitMilitaire in 'UnitMilitaire.pas',
  UnitRecord in 'UnitRecord.pas',
  UnitUpdate in 'UnitUpdate.pas',
  UnitVille in 'UnitVille.pas';

var
  Jeu: Game; // le jeu qui contient toute les donn�es d'une partie
  choix: char; // le caract�re saisie par l'utilisateur dans les menu

begin
  repeat
    gestionAcceuil(choix); // on g�re le menu accueil

    if choix = '1' then // si le joueur commence une partie
    begin
      initGame(Jeu); // on initialise le jeu

      while (Jeu.fini = false) do // boucle tant que le jeu n'est pas fini repr�sentant un tour de jeu
      begin
        gestionCivilisation(Jeu, Jeu.civilisation); // on g�re notre civilisation

        updateGame(Jeu); // quand le tour est fini on update le jeu et recommence un tour
      end;
    end;
  until choix = '2'; // on recommence jusqu'� ce que le joueur quitte le jeu

end.
