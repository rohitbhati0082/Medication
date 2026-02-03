<%@ Control Language="C#" AutoEventWireup="true" CodeFile="TeamsView.ascx.cs" Inherits="TeamsView" %>

<div class="wrapper-box">
    <div class="row" id="teamWrapper">
        <!-- Teams will be rendered here -->
    </div>
</div>

<!-- Team Card Template -->
<template id="teamTemplate">
    <div class="col-lg-4 team-block-one">
        <div class="inner-box wow fadeInUp" data-wow-delay="200ms">

            <div class="image">
                <a href="#">
                    <img src="" alt="" />
                </a>
            </div>

            <div class="lower-content">
                <h4><a href="#"></a></h4>
                <div class="designation"></div>
            </div>

        </div>
    </div>
</template>

<script>
    (function () {

        // Run after DOM is ready (NO jQuery)
        if (document.readyState === "loading") {
            document.addEventListener("DOMContentLoaded", loadTeams);
        } else {
            loadTeams();
        }

        function loadTeams() {

            fetch("/Services/ContentService.asmx/GetTeams", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json; charset=utf-8"
                },
                body: "{}"
            })
                .then(res => res.json())
                .then(result => {

                    if (!result || !result.d) return;

                    const response = JSON.parse(result.d);

                    if (!response.success || !response.data) return;

                    const container = document.getElementById("teamWrapper");
                    const template = document.getElementById("teamTemplate");

                    container.innerHTML = "";

                    response.data.forEach(item => {

                        const clone = template.content.cloneNode(true);

                        clone.querySelector("img").src = item.imageUrl;
                        clone.querySelector("img").alt = item.name;

                        clone.querySelector("h4 a").textContent = item.name;
                        clone.querySelector(".designation").textContent = item.designation;

                        container.appendChild(clone);
                    });

                    // Re-init WOW animation safely
                    if (window.WOW) {
                        new WOW().init();
                    }
                })
                .catch(() => {
                    // silent fail (no console noise)
                });
        }

    })();
</script>
