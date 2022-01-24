# # Parliamentary procedure model.
# Table and model renamed from the source schema because Rails reserves the name 'procedure'.
class ParliamentaryProcedure < ActiveRecord::Base
  
  # The procedure_routes table joins parliamentary_procedures to their routes, allowing a route to appear in many procedures and a procedure to have many routes.
  has_many :procedure_routes
  
  # A procedure may have many routes, through the procedure_routes table.
  has_many :routes, :through => 'procedure_routes'
  
  # We create an association to the work packages subject to a procedure.
  # Many work packages may be subject to the same procedure.
  has_many :work_packages
  
  # ## Method to return an array of start steps in a procedure.
  # New tables have been added to the database to reflect what we plan to happen with the [step collections](https://ukparliament.github.io/ontologies/procedure/procedure-ontology.html#d4e244) work: these place steps into a collection of start steps for a given procedure. Until this work happens, we'll need to hardcode an array.
  # This method returns an array of start steps and the name of the type of each step, to save on querying for this later.
  def start_steps
    Step.all.select('s.*, st.name as step_type_name' ).joins( 'as s, step_collections as sc, step_collection_types as sct, step_types as st' ).where( 's.id = sc.step_id' ).where( 'sc.step_collection_type_id = sct.id' ).where( 'sct.name = ?', 'Start steps' ).where( 'sc.parliamentary_procedure_id =?', self ).where( 's.step_type_id = st.id' )
  end
  
  # ## Method to return all routes which appear in a procedure, together with the name and type of the source step of each route and the name and type of the target step of each route. This saves us having to query for these later.
  def routes_with_steps
    Route.all.select( 'r.*, ss.name as source_step_name, ts.name as target_step_name, sst.name as source_step_type, tst.name as target_step_type' ).joins( 'as r, procedure_routes as pr, steps as ss, steps as ts, step_types as sst, step_types as tst' ).where( 'r.id = pr.route_id' ).where( 'pr.parliamentary_procedure_id = ?', self ).where( 'r.from_step_id = ss.id' ).where( 'r.to_step_id = ts.id' ).where( 'ss.step_type_id = sst.id' ).where( 'ts.step_type_id = tst.id' )
  end
  
  # ## Method to return all steps connected to routes in a procedure, each step having:
  # * a flag to say whether the step is in the Commons
  # * a flag to say whether the step is in the Lords
  # * a flag to say whether the step has been actualised in this work package by one or more business items having a date in the past
  # * a count of the number of actualisations of the step in this work package by one or more business items having a date in the past
  # * a flag to say whether the step has been actualised in this work package by one or more business items, regardless of the date of those business items
  # * a count of the number of concluded work packages subject to this procedure with the step being actualised
  def steps_with_actualisations_in_work_package( work_package )
    Step.find_by_sql(
      "
        SELECT
          s.*,
          SUM(commons_step.is_commons) AS is_in_commons, 
          SUM(lords_step.is_lords) AS is_in_lords,
          step_type.step_type_name,
          SUM(actualisations_has_happened.is_actualised_has_happened) AS is_actualised_has_happened,
          COUNT(actualisations_has_happened.actualised_as_happened_count) as actualised_as_happened_count,
          SUM(actualisations.is_actualised) AS is_actualised,
          SUM(work_package_count.work_package_count) AS work_package_count
        FROM steps s
        
        /* We know that steps appear in a procedure by virtue of being attached to routes in that procedure, so we join to the routes table ... */
        INNER JOIN routes r
        
        /* We know that all steps in a procedure have an inbound route and that some don't have an outbound route, so we only bind the step to the to_step_id of a route. */
          ON r.to_step_id = s.id
          
        /* We join to the procedure_routes table, using the route_id ... */
        INNER JOIN procedure_routes pr
        	ON pr.route_id = r.id
          
          /* ... ensuring we only get routes in this procedure. */
        	AND pr.parliamentary_procedure_id = #{self.id}
          
        /* We know that a step may be in one or both Houses - or none - via the house_steps table, so we left join to the house_steps table twice. */
        /* The left join ensures that the outer step query returns records for steps that are not in the House we're querying for: ... */
        
        /* ... once to check if the step is in the Commons */
        LEFT JOIN
          (
            SELECT 1 as is_commons, hs.step_id
            FROM house_steps hs
            WHERE hs.house_id = 1 -- 1 being the ID of the Commons.
            GROUP BY hs.id
          ) commons_step
          ON s.id = commons_step.step_id

        /* ... and once to check if the step is in the Lords. */
        LEFT JOIN
          (
            SELECT 1 as is_lords, hs.step_id
            FROM house_steps hs
            WHERE hs.house_id = 2 -- 2 being the ID of the Lords.
            GROUP BY hs.id
          ) lords_step
          ON s.id = lords_step.step_id
          
        /* We know that a step has a type, so we left join to step types. */
        LEFT JOIN
          (
            SELECT st.id as step_type_id, st.name as step_type_name
            FROM step_types st
          ) step_type
          ON s.step_type_id = step_type.step_type_id
          
          /* We want to get a count of the number of business items with a date in the past, or of today, having actualised a step in this work package. */
          /* We know that a step may be actualised in a work package by one or more business items having a date in the past, or of today, or having no date. A step may be within a procedure, but not actualised in a work package subject to that procedure. */
        /* The left join ensures that the outer step query returns records for steps that have not been actualised with a business item with a date in the past, or of today. */
        LEFT JOIN
          (
            SELECT 1 as is_actualised_has_happened, COUNT(a.id) as actualised_as_happened_count, a.step_id
            FROM business_items bi, actualisations a
            WHERE bi.id = a.business_item_id
              
            /* We select business items with a date in the past or of today. */
            AND bi.date <= CURRENT_DATE
              
            /* We select business items within the specified work package. */
            AND bi.work_package_id = #{work_package.id}
              
            /* We group by the ID of the step being actualised. */
            GROUP BY a.step_id
            
          ) actualisations_has_happened
          ON s.id = actualisations_has_happened.step_id
        
          /* We want to know if a step has been actualised by a business item in this work package regardless of the date of the business item. */
          /* We know that a step may be actualised in a work package by one or more business items having a date in the past, or of today, or having no date. A step may be within a procedure, but not actualised in a work package subject to that procedure. */
        /* The left join ensures that the outer step query returns records for steps that have not been actualised with a business item, regardless of the date of that business item. */
        LEFT JOIN
          (
            SELECT 1 as is_actualised, a.step_id
            FROM business_items bi, actualisations a
            WHERE bi.id = a.business_item_id
              
            /* We select business items within the specified work package. */
            AND bi.work_package_id = #{work_package.id}
              
            /* We group by the ID of the actualisation. */
            GROUP BY a.id
            
          ) actualisations
          ON s.id = actualisations.step_id
          
        /* We want to get a count of the number of concluded work packages subject to this procedure where this step has been actualised. */
        /* We left join because we want to include zero counts for work packages where this step has not been actualised. */
        LEFT JOIN
          (
            SELECT COUNT(bi.work_package_id) as work_package_count, a.step_id
            FROM business_items bi, actualisations a, work_packages wp
          
            /* We only want to include work packages marked as procedure concluded ... */
            /* ... so we inner join to work packages with business items actualising a step in the 'End steps' step collection. */
            INNER JOIN (
              SELECT wp.*
              FROM work_packages wp, business_items bi, actualisations a, steps s, step_collections sc, step_collection_types sct
              WHERE bi.work_package_id = wp.id
              AND bi.id = a.business_item_id
              AND wp.parliamentary_procedure_id = #{self.id}
              AND bi.id = a.business_item_id
              AND a.step_id = s.id
              AND s.id = sc.step_id
              AND sc.parliamentary_procedure_id = #{self.id}
              AND sc.step_collection_type_id = sct.id
              AND sct.name = 'End steps'
          
            ) concluded_work_packages
            ON concluded_work_packages.id = wp.id
            WHERE bi.id = a.business_item_id
            AND bi.work_package_id = wp.id
          
            
            /* We group by the ID of the step being actualised. */
            GROUP BY a.step_id
          
          ) work_package_count
          ON s.id = work_package_count.step_id
          
        /* We group by the step ID because the same step may be the target step of many routes and we only want to include each step once. */
        GROUP BY s.id, step_type.step_type_name;
      "
    )
  end
  
  # ## Method to return all business steps connected to routes in a procedure, each step having:
  # * a flag to say whether the step is in the Commons
  # * a flag to say whether the step is in the Lords
  # * a count of the number of concluded work packages subject to this procedure the step has been actualised in
  # The number of concluded work packages subject to this procedure the step has been actualised in is used to calculate the plausibility score for this step being taken in a work package subject to this procedure.
  def steps_with_work_package_count
    Step.find_by_sql(
      "
        SELECT
          s.*,
          SUM(commons_step.is_commons) AS is_in_commons, 
          SUM(lords_step.is_lords) AS is_in_lords,
          COUNT(work_packages.work_package_id) AS work_package_count
        FROM steps s
      
        /* We know that steps appear in a procedure by virtue of being attached to routes in that procedure, so we join to the routes table ... */
        INNER JOIN routes r
      
        /* We know that all steps in a procedure have an inbound route and that some don't have an outbound route, so we only bind the step to the to_step_id of a route. */
          ON r.to_step_id = s.id
        
        /* We join to the procedure_routes table, using the route_id ... */
        INNER JOIN procedure_routes pr
        	ON pr.route_id = r.id
        
          /* ... ensuring we only get routes in this procedure. */
        	AND pr.parliamentary_procedure_id = #{self.id}
        
        /* We know that a step may be in one or both Houses - or none - via the house_steps table, so we left join to the house_steps table twice. */
        /* The left join ensures that the outer step query returns records for steps that are not in the House we're querying for: ... */
      
        /* ... once to check if the step is in the Commons */
        LEFT JOIN
          (
            SELECT 1 as is_commons, hs.step_id
            FROM house_steps hs
            WHERE hs.house_id = 1 -- 1 being the ID of the Commons.
            GROUP BY hs.id
          ) commons_step
          ON s.id = commons_step.step_id

        /* ... and once to check if the step is in the Lords. */
        LEFT JOIN
          (
            SELECT 1 as is_lords, hs.step_id
            FROM house_steps hs
            WHERE hs.house_id = 2 -- 2 being the ID of the Lords.
            GROUP BY hs.id
          ) lords_step
          ON s.id = lords_step.step_id

          /* We want to get a count of the number of concluded work packages subject to this procedure where this step has been actualised. */
          /* We left join because we want to include zero counts for work packages where this step has not been actualised. */
        LEFT JOIN
          (
            SELECT wp.id as work_package_id, a1.step_id as counted_step_id
            FROM work_packages wp, business_items bi1, actualisations a1, business_items bi2, actualisations a2, steps s, step_collections sc, step_collection_types sct
            
            /* We check the step we're interested in has been actualised in this work package. */
            WHERE wp.parliamentary_procedure_id = #{self.id}
            AND wp.id = bi1.work_package_id
            AND bi1.id = a1.business_item_id
            
            /* We check this work package has a business item actualising a step in the step collection of type 'End steps' */
            AND wp.id = bi2.work_package_id
            AND bi2.id = a2.business_item_id
            AND a2.step_id = s.id
            AND s.id = sc.step_id
            AND sc.parliamentary_procedure_id = #{self.id}
            AND sc.step_collection_type_id = sct.id
            AND sct.name = 'End steps'
            
            GROUP BY wp.id, a1.step_id
          ) work_packages
          ON work_packages.counted_step_id = s.id
          
          /* We only want to include business steps. */
          WHERE s.step_type_id = 1
        
          /* We group by the step ID because the same step may be the target step of many routes and we only want to include each step once. */
          GROUP BY s.id
          ;
      "
    )
  end
  
  # ## Method to return all work packages subject to this procedure marked as procedure concluded.
  # This includes both Commons only and bicamerally concluded work packages.
  # The number of concluded work packages subject to a procedure is used to calculate the plausibility score of a step being taken.
  def concluded_work_packages
    WorkPackage.find_by_sql(
      "
        SELECT wp.*
        FROM work_packages wp, business_items bi, actualisations a, steps s, step_collections sc, step_collection_types sct
        WHERE wp.parliamentary_procedure_id = #{self.id}
        AND wp.id = bi.work_package_id
        AND bi.id = a.business_item_id
        AND a.step_id = s.id
        AND s.id = sc.step_id
        AND sc.parliamentary_procedure_id = #{self.id}
        AND sc.step_collection_type_id = sct.id
        AND sct.name = 'End steps'
        GROUP BY wp.id
      "
    )
  end
  
  # ## Method to return all work packages subject to this procedure marked as procedure concluded in both Houses.
  # This includes bicamerally concluded work packages only.
  # The number of concluded work packages subject to a procedure is used to calculate the plausibility score of a step being taken.
  def bicamerally_concluded_work_packages
    WorkPackage.find_by_sql(
      "
        SELECT wp.*
        FROM work_packages wp, business_items bi, actualisations a, steps s, step_collections sc, step_collection_types sct
        WHERE wp.parliamentary_procedure_id = #{self.id}
        AND wp.id = bi.work_package_id
        AND bi.id = a.business_item_id
        AND a.step_id = s.id
        AND s.id = sc.step_id
        AND sc.parliamentary_procedure_id = #{self.id}
        AND sc.step_collection_type_id = sct.id
        AND sct.name = 'Bicameral end steps'
        GROUP BY wp.id
      "
    )
  end

  # ## Method to add an ellipsis to a description of a procedure, if the description text is longer than 255 characters.
  def description_massaged
    description.length < 256 ? description : description + " ..."
  end
end