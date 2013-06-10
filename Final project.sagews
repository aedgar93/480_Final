︠b18d208a-738d-4be2-a411-da69a988c3c0︠
file_name = "List_Of_Pokemon.xml"
import xml.etree.ElementTree as ET
tree = ET.parse(file_name)
doc = tree.getroot()


type_chart = {
              "normal" : { "rock" : .5, "ghost": 0, "steel": .5},
              "fight" : {"normal" : 2, "flying" : .5, "poison" : .5, "rock": 2, "bug" : .5, "ghost" : 0, "steel" : 2, "psychic" : .5, "ice" : 2, "dark" : 2 },
              "flying" : {"fight" : 2, "rock" : .5, "bug" : 2, "steel": .5, "grass" : 2, "electric" : .5},
              "posion" : { "posion" : .5, "ground" : .5, "rock" : .5, "ghost" : .5, "steel" : 0, "grass" : 2 },
              "ground" : {"flying" : 0, "poision" : 2, "rock" : 2, "big" : .5, "steel" : 2, "fire": 2, "grass" : .5, "electric" : 2},
              "rock" : {"fight" : .5, "flying" : 2, "ground" : .5, "bug" : 2, "steel" : .5, "fire" : 2, "ice" : 2},
              "bug" : {"fight" : .5, "flying" : .5, "poison" : .5, "ghost" : .5, "steel" : .5, "fire" : .5, "grass" : 2, "psychic" : 2, "dark" : 2},
              "ghost" : {"normal" : 0, "ghost" : 2, "steel" : .5, "psychic" : 2, "dark" : .5},
              "steel" : {"rock" : 2, "steel" : .5, "fire" : .5, "water" : .5, "electric" : .5, "ice" : 2},
              "fire" : {"rock" : .5, "bug" : 2, "steel" : 2, "fire" : .5, "water" : .5, "grass" : 2, "ice" : 2, "dragon" : .5},
              "water" : {"ground" : 2, "rock" :2, "fire" : 2, "water" : .5, "grass" : .5, "dragon" : .5},
              "grass" : {"flying" : .5, "posion" : .5, "ground" : 2, "rock" : 2, "bug" : .5, "steel" : .5, "fire" : .5, "water" : 2, "grass" : .5, "dragon" : .5},
              "electric" : {"flying" : 2, "ground" : 0, "water" : 2, "grass" : .5, "electric" : .5, "dragon" : .5},
              "psychic"  :{"fight" : 2, "posion" : 2, "steel" : .5, "psychic" : .5, "dark" : 0},
              "ice" : {"flying" : 2, "ground" : 2, "steel" : .5, "fire" : .5, "water" : .5, "grass" : 2, "ice" : .5, "dragon" : 2},
              "dragon" : {"steel" : .5, "dragon" : 2},
              "dark" : {"fight" : .5, "ghost" : 2, "steel" : .5, "psychic" : 2, "dark" : .5}
              }

class Attack(object):
    def __init__(self, name):
        attack = doc.find("attack[@id='"+ name + "']")
        if attack == None:
            raise Exception("attack does not exist")
        self.name = name
        self.element = attack.find("element").text
        self.attributes = {}
        for child in attack.find("attributes"):
            self.attributes[child.tag] = child.text

    def __str__(self):
        return self.name+ " " + str(self.attributes)

    def __repr__(self):
        return self.name+ " " + str(self.attributes)

    @staticmethod
    def create(name, element, power, accuracy, special = False ):
        if doc.find("attack[@id='"+ name + "']") != None:
            raise Exception("attack already exists")
        attack = ET.SubElement(doc,"attack", {"id" : name})
        attributes = ET.SubElement(attack, "attributes")
        temp_el = ET.SubElement(attack, "element")
        temp_el.text = element
        temp_pwr = ET.SubElement(attributes, "power")
        temp_pwr.text = str(power)
        temp_acc = ET.SubElement(attributes, "accuracy")
        temp_acc.text = str(accuracy)
        temp_sp = ET.SubElement(attributes, "special")
        temp_sp.text = str(special)
        tree.write(file_name)

#Create Pokemon Object
class Pokemon(object):
    #Makes an instance of a pokemon using the xml template
    def __init__(self, name, attributes = None, attacks = [Attack("tackle")]):
        xml_element = doc.find("pokemon[@id='"+ name + "']")
        if xml_element == None:
            raise Exception("Pokemon does not exists, please use Pokemon.create")
        self.xml_element = xml_element
        self.element = xml_element.find("element").text
        self.name = name
        self.attributes = {}
        self.set_attributes(attributes)
        if len(attacks)< 4:
            self.attacks = []
            for attack in attacks:
                self.attacks.append(Attack(attack))

    def __str__(self):
        return self.name+ " " + str(self.attributes)

    def __repr__(self):
        return self.name+ " " + str(self.attributes)


    #set the attributes for self
    #if not all necessary attributes are passes then they will be filled in with the xml attributes
    def set_attributes(self, attributes):
        if attributes != None:
            self.attributes = attributes
            #check that all attributes are filled
            for child in self.xml_element.find("attributes"):
                if child.tag not in self.attributes:
                    #If an attribute is not filled use the xml attribute
                    self.attributes[child.tag] = int(child.text)

        else: #get xml attributes
            for child in self.xml_element.find("attributes"):
                self.attributes[child.tag] = int(child.text)

    #adds up to 4 attacks to a pokemon
    #attacks is a list of strings, the method will convert them to type attack
    def add_attacks(self, attacks):
        for attack in attacks:
            if len(self.attacks) < 4:
                attack = Attack(attack)
                self.attacks.append(attack)

    #If the position is valid the attack at that position will be replaced
    #If the position does not exist the attack will be added to the end
    #attack is a string, the method will convert it to type attack
    def add_attack_at_index(self, position, attack):
        attack = Attack(attack)
        if len(self.attacks) > position:
            self.attacks[position] = attack
        elif len(self.attacks) < 4:
            self.attacks.append(attack)

    #a function that creates the xml outline for a pokemon
    @staticmethod
    def create(name, attributes, element):
        necessary_attrib = ["level","hp","attack" ,"defense","sp_atk", "sp_def","speed"]
        if doc.find("pokemon[@id='"+ name + "']") != None:
            raise Exception("Pokemon already exists")
        #check to make sure all attributes were passed in
        for attrib in necessary_attrib:
            if attrib not in attributes:
                raise Exception(attrib +" attribute is mising")
        #create xml element
        poke = ET.SubElement(doc,"pokemon", {"id" : name})
        el = ET.SubElement(poke, "element")
        el.text = element
        new_attrib = ET.SubElement(poke, "attributes")
        for attrib in attributes:
            temp = ET.SubElement(new_attrib, attrib)
            temp.text = str(attributes[attrib])
        tree.write(file_name);







#Attack.create("headbutt", "normal", 100, 100);
attributes = {"level": 50,"hp": 150,"attack":50 ,"defense":50,"sp_atk":50, "sp_def":50,"speed":50}
#Pokemon.create("pikachu", attributes, "electric")
pika = Pokemon("pikachu",None, ["headbutt", "tackle"])


print pika


︡971dedb5-b655-467b-ad98-6d417ec3b2f2︡{"stdout":"pikachu {'level': 50, 'hp': 150, 'attack': 50, 'defense': 50, 'sp_atk': 50, 'sp_def': 50, 'speed': 50}\n"}︡
︠ad47e099-89ac-49a2-b413-e80b8ef0914b︠
