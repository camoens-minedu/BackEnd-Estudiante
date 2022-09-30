namespace MINEDU.IEST.Estudiante.ManagerDto.SecurityApi
{
    public class MenuDto
    {
        public string state { get; set; }
        public string name { get; set; }
        public string type { get; set; }
        public string icon { get; set; }
        public List<Badge>? badge { get; set; }
        public List<Saperator>? saperator { get; set; }
        public List<Child>? children { get; set; }
    }

    public class Child
    {
        public string state { get; set; }
        public string name { get; set; }
        public string? type { get; set; }
        public List<SubChild>? child { get; set; }
    }

    public class Badge
    {
        public string type { get; set; }
        public string value { get; set; }
    }

    public class Saperator
    {
        public string type { get; set; }
        public string? value { get; set; }
    }


    public class SubChild
    {
        public string state { get; set; }
        public string name { get; set; }
        public string? type { get; set; }
    }
}
