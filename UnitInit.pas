unit UnitInit;

interface

uses UnitRecord, GestionEcran, System.SysUtils;

procedure initGame(var g: Game); // initialise les donn�es du jeu

implementation

procedure initGame(var g: Game); // initialise les donn�es du jeu
begin

  g.tour := 1;
  g.fini := false;

  g.civilisation.nom := 'France';
  g.civilisation.recrutement := 0;
  g.civilisation.soldat := 30;
  g.civilisation.canon := 5;
  g.civilisation.recrutement := 0;

  g.civilisation.ville.nom := 'Paris';
  g.civilisation.ville.nourriture := 0;
  g.civilisation.ville.population := 1;
  g.civilisation.ville.ferme := 0;
  g.civilisation.ville.mine := 0;
  g.civilisation.ville.carriere := 0;
  g.civilisation.ville.caserne := 0;
  g.civilisation.ville.construction := -1;
  g.civilisation.ville.avancementConstruction := 0;

end;

end.
