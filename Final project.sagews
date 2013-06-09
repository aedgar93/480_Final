file_name = "List_Of_Pokemon.xml"
import xml.etree.ElementTree as ET
tree = ET.parse(file_name)
doc = tree.getroot()

#Create Pokemon Object

class Pokemon(object):
    #Makes an instance of a pokemon using the xml template
    def __init__(self, name, attributes = None, attacks = None):
        xml_element = doc.find("pokemon[@id='"+ name + "']")
        if xml_element == None:
            raise Exception("Pokemon does not exists, please use Pokemon.create")
        self.xml_element = xml_element
        self.name = name
        self.set_attributes(attributes)
        if attacks != None:
            self.attacks = attacks
        else: #get xml attacks
            self.attacks = None



    ####### NEEDS TO BE TESTED ###########
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
            self.attributes = temp


    #a function that creates the xml outline for a pokemon
    @staticmethod
    def create(name, attributes, element, attacks = None):
        necessary_attrib = ["level","hp","attack" ,"defense","sp_atk", "sp_def","speed"]
        if doc.find("pokemon[@id='"+ name + "']") != None:
            raise Exception("Pokemon already exists")
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
        if attacks == None:
            attacks = [default_attack]
        #build the xml for attacks
        tree.write(file_name);





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



    @staticmethod
    def create(name, element, power, accuracy):
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
        tree.write(file_name)

#Attack.create("tackle", "normal", 100, 100);
tackle = Attack("tackle")
#attributes = {"level": 50,"hp": 150,"attack":50 ,"defense":50,"sp_atk":50, "sp_def":50,"speed":50}
#pika = Pokemon.create("pikachu", attributes, "electric")
#squirt = Pokemon("squirtle")








︡e2d4538b-bf28-4730-9c9d-93790d955526︡{"stdout":"normal\n"}︡
︠ad47e099-89ac-49a2-b413-e80b8ef0914b︠
