#include <iostream>
#include <math.h>
using namespace std;

#define n 8
#define k 3
#define dim 2
#define MAX_CLUSTERS 16
#define MAX_ITERATIONS 100
#define BIG_float 1000000000000000.0
#define DELTA 0.01

float calculateDistance(float p1[dim], float p2[dim])
{
    float distance = 0;

    for (int i = 0; i < dim; i++)
		distance += (p1[i] - p2[i])*(p1[i] - p2[i]);

    return distance;

}

void find_next_centroid(float x[n][dim],float cluster_centroid[k][dim],int m)
{
    int i,j,l,error=0;
    int index=0,avg=0,max_avg_distance=0;
    if(m==0)
        for(i=0;i<dim;i++)
        {
        cluster_centroid[m][i]=x[m][i];
        //cout<<"salam0";
        }
    else
    {
        for(i=0;i<n;i++)
        {
            error=0;
            for(l=0;l<m;l++)
            {
                for(j=0;j<dim;j++)
                    if(x[i][j] == cluster_centroid[l][j])
                        error=1;

            }
            //cout<<"salam"<<i<<endl;
            if(error)
                continue;
            avg=0;
            for(j=0;j<m;j++)
            {
                avg+=sqrt(calculateDistance(x[i],cluster_centroid[j]))/m;
            }
            if(avg>max_avg_distance)
            {
                index = i;
                max_avg_distance = avg;
            }
        }
    for(i=0;i<dim;i++)
        cluster_centroid[m][i]=x[index][i];
    }

}

void init(float x[n][dim], float cluster_centroid[k][dim])
{
    int i;
	for(i=0;i<n;i++)
    {
		for(int j=0;j<dim;j++)
			cin>>x[i][j];
    }
    for(i=0;i<k;i++)
    {
        find_next_centroid(x,cluster_centroid,i);
    }
    for(i=0;i<k;i++)
    {
    cout<<"centroid "<<i<<" =("<<cluster_centroid[i][0]<<","<<cluster_centroid[i][1]<<")"<<endl;
    }

}

void calculateDistancesMatrix(float x[n][dim], float centroid[k][dim], float distance[n][k])
  {
    for (int i = 0; i < n; i++)		// for each point
		for (int j = 0; j < k; j++)	// for each cluster
			distance[i][j] = calculateDistance(x[i], centroid[j]);
  }

void calculateClusters(float x[n][dim], float cluster_centroid[k][dim], int cluster_assignment_index[n])
  {
	  float distance_array[n][k];
	  calculateDistancesMatrix(x,cluster_centroid,distance_array);

	  for (int i = 0; i < n; i++)
      {
        int best_index = -1;
        float closest_distance = BIG_float;
		for (int j = 0; j < k; j++)
        {
			float cur_distance = distance_array[i][j];
            if (cur_distance < closest_distance)
            {
                best_index = j;
                closest_distance = cur_distance;
            }
        }
        cluster_assignment_index[i] = best_index;
      }
  }

void calculateClustersCentroids(float x[n][dim], int cluster_assignment_index[n], float new_cluster_centroid[n][dim])
  {
    int cluster_member_count[MAX_CLUSTERS];
	for (int i = 0; i < k; i++)
    {
		cluster_member_count[i] = 0;
        for (int j = 0; j < dim; j++)
          new_cluster_centroid[i][j] = 0;
    }

	for (int i = 0; i < n; i++)
    {
		int active_cluster = cluster_assignment_index[i];
		cluster_member_count[active_cluster]++;

		for (int j = 0; j < dim; j++)
          new_cluster_centroid[active_cluster][j] += x[i][j];
    }
	for (int i = 0; i < k; i++)
    {
        if (cluster_member_count[i] != 0)
			for (int j = 0; j < dim; j++)
				new_cluster_centroid[i][j] /= cluster_member_count[i];
    }
  }

float calculateTotalDistance(float x[n][dim], float centroids[k][dim], int cluster_assignment_index[n])
  {
    float tot_D = 0;
    for (int i = 0; i < n; i++)
	{
		int active_cluster = cluster_assignment_index[i];
		if (active_cluster != -1)
			tot_D += calculateDistance(x[i], centroids[active_cluster]);
	}
    return tot_D;
  }

void calculateClustersMembersCount(int cluster_assignment_index[n], int cluster_member_count[k])
  {
	for (int i = 0; i < k; i++)
      cluster_member_count[i] = 0;
	for (int i = 0; i < n; i++)
      cluster_member_count[cluster_assignment_index[i]]++;
  }

void arraysCopy(int *src, int *tgt, int len)
  {
    for (int i = 0; i < len; i++)
      tgt[i] = src[i];
  }

int arraysDifference(int *src, int *tgt, int len)
  {
    int change_count = 0;

    for (int i = 0; i < len; i++)
		if (src[i] != tgt[i])
			change_count++;

    return change_count;
  }

void print(float x[n][dim], int cluster_assignment_index[n], float cluster_centroid[k][dim])
  {
	for (int i = 0; i < k; i++)
	{
		for (int j = 0; j < dim; j++)
			cout<<(short)cluster_centroid[i][j]<<" ";
		cout<<"\t";
	}
	cout<<endl<<"->\t";
	for (int i = 0; i < n; i++)
		cout<<cluster_assignment_index[i]<<"\t";
	cout<<endl;
  }

void kmeans(float x[n][dim], float cluster_centroid[k][dim], int cluster_assignment_final[n])
  {
	float dist[n][k];
    int   cluster_assignment_cur[n];
    int   cluster_assignment_prev[n];
    float point_move_score[n][k];

	// initial setup
    calculateClusters(x, cluster_centroid, cluster_assignment_cur);
    arraysCopy(cluster_assignment_cur, cluster_assignment_prev, n);

	float prev_totD = BIG_float;
    int batch_iteration = 0;
    while (batch_iteration < MAX_ITERATIONS)
    {
		print(x, cluster_assignment_cur, cluster_centroid);

		// update cluster centroids
		calculateClustersCentroids(x, cluster_assignment_cur, cluster_centroid);

        // see if we've failed to improve
		float totD = calculateTotalDistance(x, cluster_centroid, cluster_assignment_cur);
		if ((prev_totD-totD)<DELTA)
        {
			arraysCopy(cluster_assignment_prev, cluster_assignment_cur, n);
            calculateClustersCentroids(x, cluster_assignment_cur, cluster_centroid);
            break;
		}

		arraysCopy(cluster_assignment_cur, cluster_assignment_prev, n);
        calculateClusters(x, cluster_centroid, cluster_assignment_cur);

		// done with this phase if nothing has changed
		int change_count = arraysDifference(cluster_assignment_cur, cluster_assignment_prev, n);
        if (change_count == 0 && batch_iteration >10)
			break;

        prev_totD = totD;
        batch_iteration++;
	}

	// write to output array
    arraysCopy(cluster_assignment_cur, cluster_assignment_final, n);
  }

int main()
{
    float x[n][dim];
    float centers[k][dim];
    int assignment_final[n];
	init(x,centers);
	kmeans(x,centers,assignment_final);

    return 0;
}
