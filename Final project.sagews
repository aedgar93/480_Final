︠00390e8a-5a53-4d51-b2fa-0d8517d8f012︠

︠42bf6d71-d45f-465d-bb52-3a74cd349ded︠

︠b2c6b508-9628-413c-b241-dd8eeecd6272︠
file_name = "List_Of_Pokemon.xml"
import xml.etree.ElementTree as ET
tree = ET.parse(file_name)
doc = tree.getroot()

default_attack = Attack("tackle", "normal", 100, 100);

#Create Pokemon Object

class Pokemon(object):
    #Makes an instance of a pokemon using the xml template
    def __init__(self, name, attributes = None, attacks = None):
        element = doc.find("pokemon[@id='"+ name + "']")
        if element == None:
            raise Exception("Pokemon does not exists, please use Pokemon.create")
        self.xml_element = element
        self.name = name
        self.set_attributes(attributes, element)
        if attacks != None:
            self.attacks = attacks
        else: #get xml attacks
            self.attacks = None


    #set the attributes for self
    #if not all necessary attributes are passes then they will be filled in with the xml attributes
    def set_attributes(self, attributes):
        temp = {};
        for child in self.xml_element.find("attributes"):
                temp[child.tag] = int(child.text)
        if attributes != None:
            self.attributes = attributes
            #somehow check that all attributes are filled
            for child in temp:
                if child not in self.attributes:
                    self.attributes[child] = temp[child]

        else: #get xml attributes
            self.attributes = temp


    #a function that creates the xml outline for a pokemon
    @staticmethod
    def create(name, attributes, element, attacks = None):
        necessary_attrib = ["level","hp","attack" ,"defence","sp_atk", "sp_def","speed"]
        if doc.find("pokemon[@id='"+ name + "']") != None:
            raise Exception("Pokemon already exists, please use edit")
        #check to make sure all attributes were passed in
        for attrib in necessary_attrib:
            if attrib not in attributes:
                raise Exception(attrib +" attribute is mising")
        #create xml element
        poke = ET.SubElement(doc,"pokemon", {"id" : name})
        new_attrib = ET.SubElement(poke, "attributes")
        for attrib in attributes:
            temp = ET.SubElement(new_attrib, attrib)
            temp.text = str(attributes[attrib])
        if attacks = None
            attacks = [default_attack]
        #build the xml for attacks
        tree.write(file_name);





class Attack(object):
    def __init__(self, name, element, power, accuracy):
        self.name = name
        self.element = element
        self.power = power
        self.accuracy = accuracy

attributes = {"level": 50,"hp": 150,"attack":50 ,"defence":50,"sp_atk":50, "sp_def":50,"speed":50}
pika = Pokemon("pikachu", attributes)
Pokemon.create("squirtle", attributes, "water")
squirt = Pokemone("squirtle")








︡33b5c436-6807-4893-8af8-728f68172bbb︡{"stderr":"Error in lines 57-57\nTraceback (most recent call last):\n  File \"/mnt/home/eqeA7g9D/.sagemathcloud/sage_server.py\", line 412, in execute\n    exec compile(block, '', 'single') in namespace, locals\n  File \"\", line 1, in <module>\n  File \"\", line 32, in create\nException: Pokemon already exists, please use edit\n"}︡
︠ad47e099-89ac-49a2-b413-e80b8ef0914b︠
