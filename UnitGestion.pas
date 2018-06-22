unit UnitGestion;

interface

uses GestionEcran, UnitMilitaire, UnitVille, System.SysUtils, UnitRecord,
  UnitAffichage;

procedure gestionCivilisation(var g: Game; var c: Civilisation);
// gère les actions à partir de l'écran de civilisation
procedure gestionAcceuil(var c: Char);
// gère les actions à partir du menu principal

implementation

procedure gestionMilitaire(var g: Game; var c: Civilisation);
// gère les actions à partir du menu militaire
var
  choix: Char; // caractère saisi par l'utilisateur
begin
  repeat
    choix := '&';
    afficheMilitaire(g, c);
    readln(choix);
    case choix of
      // recrutement
      '1' .. '2':
        begin
          if c.recrutement > StrToInt(choix) - 1 then
          begin
            if choix = '1' then
            begin
              if c.ville.caserne > 0 then
                Recruter(c, StrToInt(choix))
              else
                messageGlobal := 'Aucune caserne';
            end;

            if choix = '2' then
            begin
              if c.ville.mine > 0 then
                Recruter(c, StrToInt(choix))
              else
                messageGlobal := 'Aucune mine';
            end;
          end
          else
          begin
            messageGlobal := 'Pas de point de recrutement';
          end;
        end;

        // attaque contre ville
      '3' .. '4':
        begin
          if c.soldat + c.canon > 0 then
          begin
            attaquerBarbare(g, c, StrToInt(choix) - 2);
          end
          else
          begin
            messageGlobal := 'Aucune troupe';
          end;
        end;
    end;
  until (choix = '0');
end;

procedure gestionVille(var g: Game; var v: ville);
// gère les actions à partir du menu de ville
var
  choix: Char; // caractere saisi par l'utilisateur
begin
  repeat
    afficheVille(g, v);
    readln(choix);

    // construction
    if (v.construction = -1) and (choix >='1') and (choix <='4') then // si aucune construction en cours
    begin
      if (sommeBatiment(v)<>v.population) then // si assez de population
      begin
        if ((StrToInt(choix)=1) and (v.ferme=3)) OR ((StrToInt(choix)=2) and (v.mine=3)) or ((StrToInt(choix)=3) and (v.carriere=3)) or ((StrToInt(choix)=4) and (v.caserne=3)) then //si le niveau max n'est pas atteint
          messageGlobal := 'Impossible batiment niveau max'
        else
          v.construction := StrToInt(choix);
      end
      else
        messageGlobal:= 'Impossible population insuffisante';
    end
    else if (choix >='1') and (choix <='4') then
    messageGlobal := 'Impossible construction deja en cours';
  until (choix = '0');
end;

procedure gestionCivilisation(var g: Game; var c: Civilisation);
// gère les actions à partir de l'écran de civilisation
var
  choix: Char; // caractere saisi par l'utilisateur
begin
  repeat
    choix := '&';
    afficheCivilisation(g, g.Civilisation);
    readln(choix);
    case choix of
      // gestion ville
      '1':
        gestionVille(g, g.Civilisation.ville);
      // gestion militaire
      '2':
        gestionMilitaire(g, g.Civilisation);
      // si quitter
      '0':
        g.fini := true;
    end;
  until (choix = '0') or (choix = '9');
end;

procedure gestionAcceuil(var c: Char);
// gère les actions à partir du menu principal
var
  choix: Char; // caractere saisi par l'utilisateur
begin
  afficheAccueil;
  readln(c);
end;

end.
