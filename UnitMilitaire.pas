unit UnitMilitaire;

interface

uses UnitRecord, UnitAffichage, GestionEcran, System.SysUtils;

procedure recruter(var c: Civilisation; unite: integer);
// recrute une unit� de type 'unite' pour la civilisation 'c'
procedure attaquerBarbare(var g: Game; var c: Civilisation; niveau: integer);
// commence un combat contre un camp de barbare de rang 'niveau'

implementation

procedure attaquerBarbare(var g: Game; var c: Civilisation; niveau: integer);
// commence un combat contre un camp de barbare de rang 'niveau'
var
  soldatE, canonE: integer; // entier repr�sentant le nombre de soldat et de canon ennemi
  cibleCorrecte: boolean; // boolean indiquant si une cible est correcte ou non
  cible: integer; // entier representant la cible vis� par une attaque (1:soldat, 2:canon)
  kill: integer; // entier representant le nombre de victime faite par une attaque
  str: string; // chaine representant le message du popup de fin
begin

  Randomize;

  soldatE := (random(20) + 5) * niveau;
  canonE := (random(10) + 1) * niveau;

  while (soldatE + canonE > 0) AND (c.soldat + c.canon > 0) do
  begin

    // on demande une cible jusqu'a ce qu'elle soit correcte
    cibleCorrecte := false;
    repeat

      afficheCombat(g, c, niveau, soldatE, canonE);

      readln(cible);

      if (cible = 1) and (soldatE > 0) then
        cibleCorrecte := true
      else if (cible = 2) and (canonE > 0) then
        cibleCorrecte := true
      else
        messageGlobal := 'Cible incorrecte';

    until cibleCorrecte;

    // calcul le nombre de morts de vos forces
    kill := random(c.soldat + c.canon * 2 + 1);

    messageCombat := 'Vous demander � vos troupe d''attaquer les ';

    case cible of
      1:
        begin
          soldatE := soldatE - kill;
          messageCombat := messageCombat + 'soldats ';
        end;
      2:
        begin
          canonE := canonE - kill;
          messageCombat := messageCombat + 'canons ';
        end;
    end;
    messageCombat := messageCombat + 'ennemis et elles en tuent ' + IntToStr(kill) + '.';
    if soldatE < 0 then
      soldatE := 0;
    if canonE < 0 then
      canonE := 0;

    // choix cible ennemie
    cibleCorrecte := false;
    repeat
      sleep(10);
      cible := random(2) + 1;
      if (cible = 1) and (c.soldat > 0) then
        cibleCorrecte := true;
      if (cible = 2) and (c.canon > 0) then
        cibleCorrecte := true;
    until cibleCorrecte;

    // calcul le nombre de morts des forces ennemies
    sleep(100);
    kill := random(soldatE + canonE * 2 + 1);

    messageCombat := messageCombat + 'Les forces ennemies attaquent vos ';

    case cible of
      1:
        begin
          c.soldat := c.soldat - kill;
          messageCombat := messageCombat + 'soldats ';
        end;
      2:
        begin
          c.canon := c.canon - kill;
          messageCombat := messageCombat + 'canons ';
        end;
    end;
    messageCombat := messageCombat + 'et elles en tuent ' + IntToStr(kill) + '.';
    if c.soldat < 0 then
      c.soldat := 0;
    if c.canon < 0 then
      c.canon := 0;

  end;

  case niveau of
    1:
      str := 'Combat contre : Petit camps barbare';
    2:
      str := 'Combat contre : Grand camps barbare';
  end;

  // si le combat est perdu
  if c.soldat + c.canon = 0 then
  begin
    affichePopup(g, str, 'Vous avez perdu le combat');
    messageCombat := '';
  end
  // si le combat est gagn�
  else
  begin
    affichePopup(g, str, 'Vous avez gagnez le combat');
    messageCombat := '';
  end;

end;

procedure recruter(var c: Civilisation; unite: integer);
// recrute une unit� de type 'unite' pour la civilisation 'c'
begin
  case unite of
    // recrutement soldat
    1:
      begin
        c.soldat := c.soldat + 1;
        c.recrutement := c.recrutement - 1;
      end;
    // recrutement canon
    2:
      begin
        c.canon := c.canon + 1;
        c.recrutement := c.recrutement - 2;
      end;
  end;

end;

end.
