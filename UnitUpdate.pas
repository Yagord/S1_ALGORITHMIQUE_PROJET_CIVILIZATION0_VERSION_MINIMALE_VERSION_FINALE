unit UnitUpdate;

interface

uses UnitVille, UnitRecord, UnitGestion, GestionEcran;

procedure updateGame(var g: Game);
// met à jour le jeu entre chaque tour

implementation

procedure updateBatiments(var v: Ville);
// met a jour les batiments
begin

  // si une construction est en cours
  if v.construction <> -1 then
  begin
    v.avancementConstruction := v.avancementConstruction + travailParTour(v);
  end;

  // si une construction est terminée
  if v.avancementConstruction >= travailRequis(v) then
  begin
    case v.construction of
      1:
        v.ferme := v.ferme + 1;
      2:
        v.mine := v.mine + 1;
      3:
        v.carriere := v.carriere + 1;
      4:
        v.caserne := v.caserne + 1;
    end;
    v.construction := -1;
    v.avancementConstruction := 0;
  end;

end;

procedure updateVille(var v: Ville);
// met à jour la ville
begin

  // update de l'avancement des construction
  updateBatiments(v);

  v.nourriture := v.nourriture + nourritureParTour(v);

  // update de la croissance
  repeat
    if nourriturePourCroissance(v) <= v.nourriture then
    begin
      v.nourriture := v.nourriture - nourriturePourCroissance(v);
      v.population := v.population + 1;
    end;
  until nourriturePourCroissance(v) > v.nourriture;

end;

procedure updateCivilisation(var c: Civilisation);
// met à jour la civilisation
begin

  updateVille(c.Ville); // update de la ville
  c.recrutement := c.Ville.caserne * 3; // update des points de recrutement

end;

procedure updateGame(var g: Game);
// met à jour le jeu entre chaque tour
begin

  updateCivilisation(g.Civilisation); // update de la civilisation
  effacerEcran();
  g.tour := g.tour + 1;

end;

end.
