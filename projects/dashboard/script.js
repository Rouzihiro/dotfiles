//
// Clock
//

function updateClock() {

    const now = new Date();

    document.getElementById("clock").textContent =
        now.toLocaleTimeString();

}

setInterval(updateClock, 1000);

updateClock();





//
// System information
//

async function updateSystem() {

    try {

        const data = await fetch("data/system.json?" + Date.now())
            .then(r => r.json());


        document.getElementById("cpu").textContent =
            data.cpu;

        document.getElementById("ram").textContent =
            data.ram;

        document.getElementById("disk").textContent =
            data.disk;

        document.getElementById("uptime").textContent =
            data.uptime;


    } catch (error) {

        console.log("System data unavailable", error);

    }

}





//
// Network information
//

async function updateNetwork() {

    try {

        const data = await fetch("data/network.json?" + Date.now())
            .then(r => r.json());


        document.getElementById("ssid").textContent =
            data.ssid;

        document.getElementById("signal").textContent =
            data.signal;

        document.getElementById("download").textContent =
            data.download;

        document.getElementById("upload").textContent =
            data.upload;


    } catch (error) {

        console.log("Network data unavailable", error);

    }

}





//
// Git information
//

async function updateGit() {

    try {

        const data = await fetch("data/git.json?" + Date.now())
            .then(r => r.json());


        document.getElementById("git-status").textContent =
            data.branch + " • " + data.status;


    } catch(error) {

        console.log("Git data unavailable", error);

    }

}


async function updateGitTree(){

    try {

        const data = await fetch(
            "data/git-tree.txt?" + Date.now()
        ).then(r => r.text());


        document.getElementById("git-tree").textContent =
            data;


    } catch(error){

        console.log("Git tree unavailable");

    }

}


//
// Hardware information
//

async function updateHardware(){

    try {

        const data = await fetch("data/hardware.json?" + Date.now())
            .then(r => r.json());


        document.getElementById("temperature").textContent =
            data.temperature;


        document.getElementById("battery").textContent =
            data.battery;


    } catch(error) {

        console.log("Hardware data unavailable", error);

    }

}





//
// Services information
//

async function updateServices(){

    try {

        const data = await fetch("data/services.json?" + Date.now())
            .then(r => r.json());


        document.getElementById("ssh-status").textContent =
            data.ssh;


        document.getElementById("pipewire-status").textContent =
            data.pipewire;


        document.getElementById("wireplumber-status").textContent =
            data.wireplumber;


        document.getElementById("sway-status").textContent =
            data.sway;


    } catch(error) {

        console.log("Services data unavailable", error);

    }

}





//
// Launch TUI applications
//

function openApp(app) {

    fetch("http://localhost:9999/" + app);

}





//
// Initial load
//

updateSystem();
updateNetwork();
updateGit();
updateGitTree();
updateHardware();
updateServices();







//
// Refresh
//

setInterval(updateSystem, 5000);
setInterval(updateNetwork, 5000);
setInterval(updateGit, 5000);
setInterval(updateGitTree,5000);
setInterval(updateHardware, 5000);
setInterval(updateServices, 5000);
