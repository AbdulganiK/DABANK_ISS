import java.util.*;

class Replica {
    String name;
    int x;

    public Replica(String name, int initialValue) {
        this.name = name;
        this.x = initialValue;
    }

    public int read() {
        return x;
    }

    public void write(int newValue) {
        x = newValue;
        System.out.println("[" + name + "] x := " + newValue);
    }
}

class Client {
    String name;
    List<Integer> readHistory = new ArrayList<>();
    List<Integer> writeHistory = new ArrayList<>();
    List<String> readSources = new ArrayList<>();

    // Zähler für Verstöße
    int readYourWritesViolations = 0;
    int monotonicReadsViolations = 0;

    public Client(String name) {
        this.name = name;
    }

    public void write(Replica r, int value) {
        System.out.println(name + " schreibt " + value + " auf " + r.name);
        r.write(value);
        writeHistory.add(value);
    }

    public void read(Replica r) {
        int v = r.read();
        System.out.println(name + " liest von " + r.name + ": x = " + v);
        readHistory.add(v);
        readSources.add(r.name);
    }

    public void checkReadYourWrites() {
        if (writeHistory.getLast() != readHistory.getLast()  ){
            readYourWritesViolations ++;
        }
    }

    public void checkMonotonicReads() {
        if (readHistory.size() < 2) {
            return;
        }
        int previous = readHistory.get(readHistory.size() - 2);
        int current = readHistory.getLast();
        if (current < previous) {
            monotonicReadsViolations++;
        }
    }

    public void printSummary() {
        System.out.println("\n===== Konsistenz-Zusammenfassung für " + name + " =====");
        System.out.println("ReadYourWrites-Verletzungen   : " + readYourWritesViolations);
        System.out.println("MonotonicReads-Verletzungen   : " + monotonicReadsViolations);
        System.out.println("=====================================================");
    }
}

public class Main {
    public static void main(String[] args) {
        Replica A = new Replica("A", 0); // schneller Replikat
        Replica B = new Replica("B", 0); // verzögerter Replikat

        Client c1 = new Client("Client1");

        // T0: write(10) auf A
        c1.write(A, 10);
        // Hier muss nicht geprüft werden, da kein Lesevorgang

        // T1: read() von B → noch alt
        c1.read(B);
        c1.checkReadYourWrites();
        c1.checkMonotonicReads();

        // T2: read() von A → korrekt
        c1.read(A);
        c1.checkReadYourWrites();
        c1.checkMonotonicReads();

        // T3: write(20) auf B
        c1.write(B, 20);
        // Hier muss nicht geprüft werden, da kein Lesevorgang

        // T4: read() von A → alt
        c1.read(A);
        c1.checkReadYourWrites();
        c1.checkMonotonicReads();

        // T5: read() von B → korrekt
        c1.read(B);
        c1.checkReadYourWrites();
        c1.checkMonotonicReads();

        // T6: read() von A → wieder älter
        c1.read(A);
        c1.checkReadYourWrites();
        c1.checkMonotonicReads();

        // Zusammenfassung
        c1.printSummary();
		
		// Erwartetes Ergebnis:
		//ReadYourWrites-Verletzungen   : 3
		//MonotonicReads-Verletzungen   : 1
    }
}