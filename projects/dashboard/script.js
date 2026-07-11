//
// Dashboard automatic data loader
//


function updateClock(){

    document.getElementById("clock").textContent =
        new Date().toLocaleTimeString();

}



async function updateFile(file){


    try {


        const data =
            await fetch(
                "data/" + file + "?" + Date.now()
            )
            .then(r => r.json());



        for(const key in data){


            const element =
                document.getElementById(key);



            if(element){

                element.textContent =
                    data[key];

            }


        }


    }


    catch(error){

        console.log(
            "Unable to load",
            file
        );

    }


}



async function updateDashboard(){


    try {


        const files =
            await fetch(
                "data/index.json?" + Date.now()
            )
            .then(r => r.json());



        for(const file of files){

            updateFile(file);

        }


    }


    catch(error){

        console.log(
            "Data index unavailable"
        );

    }


}




updateClock();


setInterval(
    updateClock,
    1000
);



updateDashboard();


setInterval(
    updateDashboard,
    5000
);




// Launcher bridge

function openApp(app){

    fetch(
        "http://localhost:9999/" + app
    );

}
