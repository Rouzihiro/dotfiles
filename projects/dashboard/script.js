//
// Dashboard automatic data loader
//


// Clock

function updateClock(){

    const clock =
        document.getElementById("clock");


    if(clock){

        clock.textContent =
            new Date().toLocaleTimeString();

    }

}



// Prevent multiple updates running at once

let updating = false;



// Load one JSON file

async function updateFile(file){


    try {


        const response =
            await fetch(
                "data/" + file + "?" + Date.now()
            );


        const data =
            await response.json();



        for(const key in data){


            const element =
                document.getElementById(key);



            if(!element){

                console.log(
                    "Missing element:",
                    key
                );

                continue;

            }



            if(element.tagName === "PRE"){

                element.textContent =
                    data[key];

            }
            else {

                element.textContent =
                    data[key];

            }


        }


    }
    catch(error){

        console.log(
            "Unable to load:",
            file,
            error
        );

    }


}



// Load all available data

async function updateDashboard(){


    if(updating){

        return;

    }


    updating = true;



    try {


        const files =
            await fetch(
                "data/index.json?" + Date.now()
            )
            .then(r => r.json());



        for(const file of files){

            await updateFile(file);

        }


    }
    catch(error){

        console.log(
            "Data index unavailable",
            error
        );

    }



    updating = false;

}




// Clock

updateClock();


setInterval(
    updateClock,
    1000
);



// Data

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
